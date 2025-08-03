<?php

namespace App\Config;

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

class Security
{
    // JWT settings
    const JWT_ALGORITHM = 'HS256';
    const JWT_ISSUER = 'study_abroad_agency';
    const JWT_AUDIENCE = 'study_abroad_users';
    
    // Password settings
    const PASSWORD_MIN_LENGTH = 8;
    const PASSWORD_REQUIRE_UPPERCASE = true;
    const PASSWORD_REQUIRE_LOWERCASE = true;
    const PASSWORD_REQUIRE_NUMBERS = true;
    const PASSWORD_REQUIRE_SPECIAL_CHARS = true;
    
    // Session settings
    const SESSION_LIFETIME = 3600; // 1 hour
    const SESSION_REFRESH_TIME = 300; // 5 minutes
    const MAX_LOGIN_ATTEMPTS = 5;
    const LOCKOUT_DURATION = 900; // 15 minutes
    
    // CSRF settings
    const CSRF_TOKEN_LENGTH = 32;
    const CSRF_TOKEN_EXPIRY = 3600; // 1 hour
    
    // Rate limiting
    const RATE_LIMIT_REQUESTS = 100; // requests per minute
    const RATE_LIMIT_WINDOW = 60; // seconds
    
    // File upload security
    const ALLOWED_FILE_EXTENSIONS = [
        'images' => ['jpg', 'jpeg', 'png', 'gif', 'webp'],
        'documents' => ['pdf', 'doc', 'docx', 'txt'],
        'archives' => ['zip', 'rar']
    ];
    
    // Input validation rules
    const VALIDATION_RULES = [
        'email' => [
            'required' => true,
            'type' => 'email',
            'max_length' => 255
        ],
        'password' => [
            'required' => true,
            'min_length' => 8,
            'max_length' => 255,
            'pattern' => '/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/'
        ],
        'name' => [
            'required' => true,
            'min_length' => 2,
            'max_length' => 100,
            'pattern' => '/^[a-zA-Z\s]+$/'
        ],
        'phone' => [
            'required' => false,
            'pattern' => '/^[\+]?[1-9][\d]{0,15}$/'
        ],
        'url' => [
            'required' => false,
            'type' => 'url',
            'max_length' => 255
        ]
    ];
    
    // XSS protection
    const XSS_ALLOWED_TAGS = [
        'p', 'br', 'strong', 'em', 'u', 'ol', 'ul', 'li', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6',
        'a', 'img', 'div', 'span', 'table', 'tr', 'td', 'th', 'thead', 'tbody'
    ];
    
    const XSS_ALLOWED_ATTRIBUTES = [
        'href', 'src', 'alt', 'title', 'class', 'id', 'style', 'target'
    ];
    
    public static function generateJWT($payload)
    {
        $payload['iat'] = time();
        $payload['exp'] = time() + self::JWT_EXPIRY;
        $payload['iss'] = self::JWT_ISSUER;
        $payload['aud'] = self::JWT_AUDIENCE;
        
        return JWT::encode($payload, App::JWT_SECRET, self::JWT_ALGORITHM);
    }
    
    public static function verifyJWT($token)
    {
        try {
            $decoded = JWT::decode($token, new Key(App::JWT_SECRET, self::JWT_ALGORITHM));
            return (array) $decoded;
        } catch (\Exception $e) {
            return false;
        }
    }
    
    public static function generateCSRFToken()
    {
        if (!isset($_SESSION[App::CSRF_TOKEN_NAME])) {
            $_SESSION[App::CSRF_TOKEN_NAME] = bin2hex(random_bytes(self::CSRF_TOKEN_LENGTH));
        }
        return $_SESSION[App::CSRF_TOKEN_NAME];
    }
    
    public static function verifyCSRFToken($token)
    {
        return isset($_SESSION[App::CSRF_TOKEN_NAME]) && 
               hash_equals($_SESSION[App::CSRF_TOKEN_NAME], $token);
    }
    
    public static function hashPassword($password)
    {
        return password_hash($password, PASSWORD_BCRYPT, ['cost' => 12]);
    }
    
    public static function verifyPassword($password, $hash)
    {
        return password_verify($password, $hash);
    }
    
    public static function validatePassword($password)
    {
        $errors = [];
        
        if (strlen($password) < self::PASSWORD_MIN_LENGTH) {
            $errors[] = "Password must be at least " . self::PASSWORD_MIN_LENGTH . " characters long";
        }
        
        if (self::PASSWORD_REQUIRE_UPPERCASE && !preg_match('/[A-Z]/', $password)) {
            $errors[] = "Password must contain at least one uppercase letter";
        }
        
        if (self::PASSWORD_REQUIRE_LOWERCASE && !preg_match('/[a-z]/', $password)) {
            $errors[] = "Password must contain at least one lowercase letter";
        }
        
        if (self::PASSWORD_REQUIRE_NUMBERS && !preg_match('/[0-9]/', $password)) {
            $errors[] = "Password must contain at least one number";
        }
        
        if (self::PASSWORD_REQUIRE_SPECIAL_CHARS && !preg_match('/[@$!%*?&]/', $password)) {
            $errors[] = "Password must contain at least one special character (@$!%*?&)";
        }
        
        return $errors;
    }
    
    public static function sanitizeInput($input, $type = 'string')
    {
        switch ($type) {
            case 'email':
                return filter_var(trim($input), FILTER_SANITIZE_EMAIL);
            case 'url':
                return filter_var(trim($input), FILTER_SANITIZE_URL);
            case 'int':
                return filter_var($input, FILTER_SANITIZE_NUMBER_INT);
            case 'float':
                return filter_var($input, FILTER_SANITIZE_NUMBER_FLOAT, FILTER_FLAG_ALLOW_FRACTION);
            case 'html':
                return self::sanitizeHTML($input);
            default:
                return htmlspecialchars(trim($input), ENT_QUOTES, 'UTF-8');
        }
    }
    
    public static function sanitizeHTML($html)
    {
        $allowedTags = implode('', self::XSS_ALLOWED_TAGS);
        $allowedAttributes = implode('|', self::XSS_ALLOWED_ATTRIBUTES);
        
        // Remove all tags except allowed ones
        $html = strip_tags($html, '<' . implode('><', self::XSS_ALLOWED_TAGS) . '>');
        
        // Remove potentially dangerous attributes
        $html = preg_replace('/\s*on\w+\s*=\s*["\'][^"\']*["\']/i', '', $html);
        $html = preg_replace('/\s*javascript\s*:/i', '', $html);
        
        return $html;
    }
    
    public static function validateFile($file, $allowedTypes = 'images')
    {
        $errors = [];
        
        if (!isset($file['tmp_name']) || !is_uploaded_file($file['tmp_name'])) {
            $errors[] = "Invalid file upload";
            return $errors;
        }
        
        if ($file['size'] > App::MAX_FILE_SIZE) {
            $errors[] = "File size exceeds maximum limit";
        }
        
        $fileExtension = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));
        $allowedExtensions = self::ALLOWED_FILE_EXTENSIONS[$allowedTypes] ?? [];
        
        if (!in_array($fileExtension, $allowedExtensions)) {
            $errors[] = "File type not allowed";
        }
        
        // Check MIME type
        $finfo = finfo_open(FILEINFO_MIME_TYPE);
        $mimeType = finfo_file($finfo, $file['tmp_name']);
        finfo_close($finfo);
        
        if ($allowedTypes === 'images' && !in_array($mimeType, App::ALLOWED_IMAGE_TYPES)) {
            $errors[] = "Invalid image type";
        }
        
        return $errors;
    }
    
    public static function generateRandomString($length = 32)
    {
        return bin2hex(random_bytes($length / 2));
    }
    
    public static function isRateLimited($identifier, $limit = null, $window = null)
    {
        $limit = $limit ?? self::RATE_LIMIT_REQUESTS;
        $window = $window ?? self::RATE_LIMIT_WINDOW;
        
        $key = "rate_limit:$identifier";
        $current = time();
        
        if (!isset($_SESSION[$key])) {
            $_SESSION[$key] = ['count' => 1, 'reset_time' => $current + $window];
            return false;
        }
        
        if ($current > $_SESSION[$key]['reset_time']) {
            $_SESSION[$key] = ['count' => 1, 'reset_time' => $current + $window];
            return false;
        }
        
        $_SESSION[$key]['count']++;
        
        return $_SESSION[$key]['count'] > $limit;
    }
}