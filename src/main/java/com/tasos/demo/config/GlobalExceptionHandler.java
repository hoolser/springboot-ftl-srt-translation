package com.tasos.demo.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.resource.NoResourceFoundException;
import jakarta.servlet.http.HttpServletRequest;

/**
 * Global exception handler for all controllers.
 * Provides centralized error handling and logging for application-wide exceptions.
 */
@ControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    /**
     * Handle NoResourceFoundException (404 errors) for static resources.
     * These are typically caused by security scanners and should not be logged as errors.
     * Displays a custom 404 error page.
     */
    @ExceptionHandler(NoResourceFoundException.class)
    public ModelAndView handleNoResourceFoundException(NoResourceFoundException ex, HttpServletRequest request) {
        // Only log at debug level to avoid cluttering logs with scanner requests
        logger.debug("Resource not found: {}", ex.getMessage());

        ModelAndView mav = new ModelAndView();
        mav.setViewName("error/404");
        mav.addObject("status", 404);
        mav.addObject("message", "The requested resource could not be found.");
        mav.addObject("requestUri", request.getRequestURI());

        return mav;
    }

    /**
     * Handle MaxUploadSizeExceededException when file size exceeds the configured limit.
     * Displays error page for payload too large (413) status.
     */
    @ExceptionHandler(MaxUploadSizeExceededException.class)
    public ModelAndView handleMaxUploadSizeExceededException(
            MaxUploadSizeExceededException ex, HttpServletRequest request) {

        logger.warn("File upload size exceeded: {}", ex.getMessage());

        ModelAndView mav = new ModelAndView();
        mav.setViewName("error/413");
        mav.addObject("status", 413);
        mav.addObject("message", "File upload failed: Maximum upload size of 7GB exceeded. Please check your file size and try again.");
        mav.addObject("requestUri", request.getRequestURI());

        return mav;
    }

    /**
     * Handle all other exceptions with a generic error message.
     */
    @ExceptionHandler(Exception.class)
    public ModelAndView handleGeneralException(Exception ex, HttpServletRequest request) {
        logger.error("An unexpected error occurred: ", ex);

        ModelAndView mav = new ModelAndView();
        mav.setViewName("error/500");
        mav.addObject("status", 500);
        mav.addObject("message", "An unexpected error occurred. Please try again later.");
        mav.addObject("requestUri", request.getRequestURI());

        return mav;
    }
}

