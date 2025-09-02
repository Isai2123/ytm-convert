# Security Configuration for Convert YTM

## Environment Variables

### Backend Security
- `ALLOWED_ORIGINS`: Comma-separated list of allowed CORS origins
- `MAX_REQUESTS_PER_WINDOW`: Rate limiting (default: 100)
- `RATE_LIMIT_WINDOW_MS`: Rate limit window in milliseconds (default: 900000)
- `CSRF_SECRET`: Secret for CSRF token generation
- `SESSION_SECRET`: Secret for session management

### Example .env file:
```
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:5173
MAX_REQUESTS_PER_WINDOW=100
RATE_LIMIT_WINDOW_MS=900000
CSRF_SECRET=your-csrf-secret-here
SESSION_SECRET=your-session-secret-here
```

## Security Features Implemented

### 1. Input Validation & Sanitization
- URL validation with regex patterns
- Path traversal prevention
- Input length limits
- Control character removal

### 2. CSRF Protection
- Token-based CSRF protection
- Header validation (X-CSRF-Token, X-Session-Token)
- State-changing operations protected

### 3. CORS Security
- Configurable allowed origins
- No wildcard (*) origins in production
- Credentials support with specific origins

### 4. Rate Limiting
- IP-based rate limiting
- Configurable limits per time window
- Protection against DoS attacks

### 5. Log Injection Prevention
- Input sanitization before logging
- Newline/control character removal
- Log message length limits

### 6. Command Injection Prevention
- URL validation before system calls
- Safe command execution with execvp
- Input sanitization for external commands

### 7. Path Traversal Prevention
- Path normalization
- Directory traversal pattern removal
- File access validation

### 8. Error Handling
- Secure error messages
- No sensitive information exposure
- Proper exception handling

## Security Headers

The application uses Helmet.js to set security headers:
- X-Content-Type-Options: nosniff
- X-Frame-Options: DENY
- X-XSS-Protection: 1; mode=block
- Strict-Transport-Security (HSTS)
- Content-Security-Policy

## Deployment Security

### Production Checklist
- [ ] Set strong CSRF and session secrets
- [ ] Configure specific CORS origins
- [ ] Enable HTTPS/TLS
- [ ] Set up proper firewall rules
- [ ] Regular security updates
- [ ] Monitor logs for suspicious activity
- [ ] Implement proper backup strategies
- [ ] Use environment variables for secrets