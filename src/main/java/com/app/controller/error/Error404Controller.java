package com.app.controller.error;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class Error404Controller {

    @RequestMapping("/error")
    public String handleError(HttpServletRequest request) {
        Object status = request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);
        
       
        if (status != null) {
            Integer statusCode = Integer.valueOf(status.toString());
            
       
            if (statusCode == HttpStatus.NOT_FOUND.value()) {
              return "error404page";
            }
        }
        
        
        return "errorScreen";
    }
    @RequestMapping("/error404")
    public String handle404Error() {
    	return "error404page";
    }
}