<?php

namespace App\Config;

class App
{
    // Application settings
    const APP_NAME = 'Study Abroad Agency';
    const APP_VERSION = '1.0.0';
    const APP_ENV = 'development'; // development, production, testing
    
    // URL and path settings
    const BASE_URL = 'http://localhost';
    const PUBLIC_PATH = '/public';
    const ADMIN_PATH = '/admin';
    const API_PATH = '/api';
    
    // File upload settings
    const MAX_FILE_SIZE = 10485760; // 10MB
    const ALLOWED_IMAGE_TYPES = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
    const ALLOWED_DOCUMENT_TYPES = ['application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'];
    const UPLOAD_PATH = '/public/uploads/';
    
    // Security settings
    const JWT_SECRET = 'your-secret-key-here';
    const JWT_EXPIRY = 3600; // 1 hour
    const CSRF_TOKEN_NAME = 'csrf_token';
    const SESSION_NAME = 'study_abroad_session';
    
    // Pagination settings
    const ITEMS_PER_PAGE = 20;
    const MAX_PAGINATION_LINKS = 5;
    
    // Email settings
    const SMTP_HOST = 'smtp.gmail.com';
    const SMTP_PORT = 587;
    const SMTP_USERNAME = 'your-email@gmail.com';
    const SMTP_PASSWORD = 'your-app-password';
    const SMTP_ENCRYPTION = 'tls';
    
    // Cache settings
    const CACHE_ENABLED = true;
    const CACHE_DURATION = 3600; // 1 hour
    
    // Analytics settings
    const GOOGLE_ANALYTICS_ID = '';
    const FACEBOOK_PIXEL_ID = '';
    
    // Social media settings
    const FACEBOOK_URL = '';
    const TWITTER_URL = '';
    const INSTAGRAM_URL = '';
    const LINKEDIN_URL = '';
    const YOUTUBE_URL = '';
    
    // Contact information
    const CONTACT_EMAIL = 'info@studyabroad.com';
    const CONTACT_PHONE = '+1 (555) 123-4567';
    const CONTACT_ADDRESS = '123 Study Abroad Street, City, Country';
    
    // Default settings
    const DEFAULT_LANGUAGE = 'en';
    const DEFAULT_TIMEZONE = 'UTC';
    const DEFAULT_CURRENCY = 'USD';
    
    // Feature flags
    const FEATURES = [
        'blog' => true,
        'forms' => true,
        'analytics' => true,
        'multi_agency' => false,
        'notifications' => true,
        'file_upload' => true,
        'seo_tools' => true,
        'backup' => true
    ];
    
    // Countries and regions
    const COUNTRIES = [
        'europe' => [
            'germany', 'france', 'italy', 'spain', 'netherlands', 
            'sweden', 'norway', 'denmark', 'switzerland', 'austria'
        ],
        'north_america' => [
            'usa', 'canada'
        ],
        'asia' => [
            'china', 'japan', 'south_korea', 'singapore', 'malaysia',
            'thailand', 'india', 'turkey'
        ],
        'oceania' => [
            'australia', 'new_zealand'
        ]
    ];
    
    // Services
    const SERVICES = [
        'university_application' => 'University Application Assistance',
        'visa_consultation' => 'Visa Consultation',
        'scholarship_guidance' => 'Scholarship Guidance',
        'accommodation_services' => 'Accommodation Services',
        'pre_departure_orientation' => 'Pre-departure Orientation',
        'language_training' => 'Language Training'
    ];
    
    // Student statuses
    const STUDENT_STATUSES = [
        'inquiry' => 'Inquiry',
        'application' => 'Application Submitted',
        'accepted' => 'Accepted',
        'visa_applied' => 'Visa Applied',
        'visa_approved' => 'Visa Approved',
        'enrolled' => 'Enrolled',
        'completed' => 'Completed',
        'cancelled' => 'Cancelled'
    ];
    
    // User roles
    const USER_ROLES = [
        'super_admin' => 'Super Administrator',
        'admin' => 'Administrator',
        'agent' => 'Agent',
        'content_manager' => 'Content Manager'
    ];
    
    // Permissions
    const PERMISSIONS = [
        'dashboard' => ['super_admin', 'admin', 'agent', 'content_manager'],
        'students' => ['super_admin', 'admin', 'agent'],
        'content' => ['super_admin', 'admin', 'content_manager'],
        'branding' => ['super_admin', 'admin'],
        'forms' => ['super_admin', 'admin', 'content_manager'],
        'analytics' => ['super_admin', 'admin'],
        'settings' => ['super_admin', 'admin'],
        'users' => ['super_admin', 'admin']
    ];
    
    public static function get($key, $default = null)
    {
        return defined("self::$key") ? constant("self::$key") : $default;
    }
    
    public static function isFeatureEnabled($feature)
    {
        return self::FEATURES[$feature] ?? false;
    }
    
    public static function hasPermission($userRole, $permission)
    {
        return in_array($userRole, self::PERMISSIONS[$permission] ?? []);
    }
    
    public static function getCountriesByRegion($region)
    {
        return self::COUNTRIES[$region] ?? [];
    }
    
    public static function getAllCountries()
    {
        $allCountries = [];
        foreach (self::COUNTRIES as $region => $countries) {
            $allCountries = array_merge($allCountries, $countries);
        }
        return $allCountries;
    }
}