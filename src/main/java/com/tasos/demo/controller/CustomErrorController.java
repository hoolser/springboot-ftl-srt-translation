package com.tasos.demo.controller;

import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;

/**
 * Custom Error Controller for rendering user-friendly error pages
 * Handles HTTP error responses (404, 500, etc.)
 */
@Controller
public class CustomErrorController implements ErrorController {

    @RequestMapping("/error")
    public ModelAndView handleError(HttpServletRequest request) {
        Object status = request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);
        Object message = request.getAttribute(RequestDispatcher.ERROR_MESSAGE);
        Object requestUri = request.getAttribute(RequestDispatcher.ERROR_REQUEST_URI);

        ModelAndView mav = new ModelAndView();
        mav.addObject("status", status);
        mav.addObject("message", message);
        mav.addObject("requestUri", requestUri);

        if (status != null) {
            int statusCode = Integer.parseInt(status.toString());

            if (statusCode == HttpStatus.NOT_FOUND.value()) {
                mav.setViewName("error/404");
            } else if (statusCode == HttpStatus.INTERNAL_SERVER_ERROR.value()) {
                mav.setViewName("error/500");
            } else if (statusCode == HttpStatus.FORBIDDEN.value()) {
                mav.setViewName("error/403");
            } else if (statusCode == HttpStatus.UNAUTHORIZED.value()) {
                mav.setViewName("error/401");
            } else if (statusCode == HttpStatus.BAD_REQUEST.value()) {
                mav.setViewName("error/400");
            } else if (statusCode == HttpStatus.SERVICE_UNAVAILABLE.value()) {
                mav.setViewName("error/503");
            } else {
                mav.setViewName("error/default");
            }
        } else {
            mav.setViewName("error/default");
        }

        return mav;
    }
}
