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
import org.springframework.web.bind.annotation.ResponseBody;

import com.app.dto.project.Project;
import com.app.dto.project.ProjectMember;
import com.app.dto.project.Schedule;
import com.app.dto.user.User;
import com.app.service.UserService;
import com.app.service.project.ProjectMemberService;
import com.app.service.project.ProjectService;
import com.app.service.project.ScheduleService;

@Controller
public class ProjectController {

	@Autowired
	ProjectService projectService;
	
	@Autowired
	ProjectMemberService projectMemberService;
	
	@Autowired
	ScheduleService scheduleService;
	
	@Autowired
	UserService userService;
	

	
	@GetMapping("/project/main/{projectId}")
	public String projectMain(@PathVariable Long projectId, Model model, HttpSession session) {
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
        
        // ✅ 멤버 리스트 내려주기 (JSP에서 ${projectMemberList}로 사용)
        List<ProjectMember> members = projectMemberService.getMembers(projectId);
        model.addAttribute("projectMemberList", members);
        
        int scheduleNum = projectService.countNumberofScheduleByProjectId(projectId);
        int scheduleDoneNum = projectService.countNumberofScheduleDoneByProjectId(projectId);
        
        model.addAttribute("scheduleNum", scheduleNum);
        model.addAttribute("scheduleDoneNum", scheduleDoneNum);
        
        User loginUser = (User) session.getAttribute("loginUser");
        
        if (loginUser == null) {
            return "redirect:/account/login";
        }
        
        String userId = loginUser.getId();
        
        List<Schedule> schedulesByUserAndProject = scheduleService.selectSchedulesByUserAndProject(userId, projectId);
        
        model.addAttribute("schedulesByUserAndProject", schedulesByUserAndProject);
        
        User pm = (User) userService.getUser(project.getManager());
        if (pm == null) {
            pm=new User();
            pm.setName("Null");
        }
        model.addAttribute("pmName", pm.getName());
        
		return "project/projectMain";
		
		
		
		
		
	}
	
	
	@GetMapping("/project/schedule/{projectId}")
	public String projectSchedule(@PathVariable Long projectId,Model model,HttpSession session) {
		  model.addAttribute("projectId", projectId);  // ✅ 이게 핵심
		// ✅ 멤버 리스트 내려주기 (JSP에서 ${projectMemberList}로 사용)
	        List<ProjectMember> members = projectMemberService.getMembers(projectId);
	        model.addAttribute("projectMemberList", members);
	        model.addAttribute("loginUser", "id1");  // ✅ 이게 핵심
	        String userRole = (String) session.getAttribute("loginUserRole");
	        boolean isAdmin ="ADMIN".equals(userRole);
	        model.addAttribute("isAdmin", isAdmin);
	        model.addAttribute("isCalendar", true);
	        
		return "project/schedule";
	}
	
	@GetMapping("/project/gantt")
	public String projectGantt() {
		return "project/gantt";
	}
	
	@GetMapping("/project/memo/{projectId}")
	public String  projectMemo(@PathVariable Long projectId,HttpSession session ,Model model) {
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
