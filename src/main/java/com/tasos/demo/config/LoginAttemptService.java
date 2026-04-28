package com.tasos.demo.config;

import org.springframework.stereotype.Service;

import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

@Service
public class LoginAttemptService {

    private final int MAX_ATTEMPT = 7;
    private final long LOCK_TIME_DURATION = 45 * 60 * 1000; // 15 mins

    private final ConcurrentMap<String, Integer> attemptsCache = new ConcurrentHashMap<>();
    private final ConcurrentMap<String, Long> lockTimeCache = new ConcurrentHashMap<>();

    public void loginSucceeded(String key) {
        attemptsCache.remove(key);
        lockTimeCache.remove(key);
    }

    public void loginFailed(String key) {
        int attempts = attemptsCache.getOrDefault(key, 0);
        attempts++;
        attemptsCache.put(key, attempts);
        if (attempts >= MAX_ATTEMPT) {
            lockTimeCache.put(key, System.currentTimeMillis());
        }
    }

    public boolean isBlocked(String key) {
        if (!lockTimeCache.containsKey(key)) {
            return false;
        }
        long lockTime = lockTimeCache.get(key);
        if (lockTime + LOCK_TIME_DURATION < System.currentTimeMillis()) {
            attemptsCache.remove(key);
            lockTimeCache.remove(key);
            return false;
        }
        return true;
    }
}

