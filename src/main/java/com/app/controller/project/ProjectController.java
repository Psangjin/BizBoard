package com.app.controller.project;

import java.time.LocalDate;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import com.app.dto.project.Project;
import com.app.dto.project.Schedule;
import com.app.dto.user.User;
import com.app.service.project.ProjectService;
import com.app.service.project.ScheduleService;

@Controller
public class ProjectController {

	@Autowired
	ProjectService projectService;
	
	@Autowired
	ScheduleService scheduleService;
	
	@GetMapping("/project/main/{projectId}")
	public String projectMain(@PathVariable Long projectId, Model model) {
		Project project = projectService.findProjectById(projectId);
		if(project == null) {
			return "redirect:/error";
		}
			
		model.addAttribute("project", project);
		
		LocalDate endDate = project.getEndDt().toInstant()
                .atZone(ZoneId.systemDefault())
                .toLocalDate();
        LocalDate today = LocalDate.now();

        long daysLeft = ChronoUnit.DAYS.between(today, endDate);

        model.addAttribute("daysLeft", daysLeft);
        
        List<Schedule> schedules = scheduleService.findSchedulesByProjectId(projectId);

        List<Schedule> todaySchedules = schedules.stream()
            .filter(s -> {
                LocalDate start = s.getStartDt().toLocalDateTime().toLocalDate();
                LocalDate end = s.getEndDt() != null
                    ? s.getEndDt().toLocalDateTime().toLocalDate()
                    : start;
                return !today.isBefore(start) && !today.isAfter(end);
            })
            .collect(Collectors.toList());

        model.addAttribute("todaySchedules", todaySchedules);
		return "project/projectMain";
		
		
		
		
		
	}
	
	
	@GetMapping("/project/schedule")
	public String projectSchedule(Model model) {
		  model.addAttribute("projectId", 1);  // ✅ 이게 핵심
		return "project/schedule";
	}
	
	@GetMapping("/project/gantt")
	public String projectGantt() {
		return "project/gantt";
	}
	
	@GetMapping("/project/memo")
	public String  projectMemo(HttpSession session ,Model model) {
		Project project = (Project)session.getAttribute("project");
		 model.addAttribute("projectId", project.getId());  // ✅ 이게 핵심
		 model.addAttribute("loginUser", "id1");  // ✅ 이게 핵심
		return "project/memo";
	}
	
	@GetMapping("/project/user")
	public String projectUser() {
		return "project/user";
	}
	
	@GetMapping("/project/newProject")
	public String  newProject() {
		return "project/newProject";
	}
}
