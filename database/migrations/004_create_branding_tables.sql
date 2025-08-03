-- Create site settings table
CREATE TABLE site_settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    setting_key VARCHAR(100) NOT NULL UNIQUE,
    setting_value TEXT,
    setting_type ENUM('string', 'number', 'boolean', 'json', 'file') DEFAULT 'string',
    is_public BOOLEAN DEFAULT FALSE,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_setting_key (setting_key),
    INDEX idx_public (is_public)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create branding config table
CREATE TABLE branding_config (
    id INT AUTO_INCREMENT PRIMARY KEY,
    main_logo VARCHAR(500),
    favicon VARCHAR(500),
    admin_logo VARCHAR(500),
    primary_color VARCHAR(7) DEFAULT '#3B82F6',
    secondary_color VARCHAR(7) DEFAULT '#64748B',
    accent_color VARCHAR(7) DEFAULT '#EAB308',
    font_family VARCHAR(100) DEFAULT 'Inter',
    custom_css TEXT,
    custom_js TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create hero sections table
CREATE TABLE hero_sections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    subtitle TEXT,
    background_image VARCHAR(500),
    background_video VARCHAR(500),
    cta_text VARCHAR(100),
    cta_link VARCHAR(255),
    cta_style JSON,
    overlay_color VARCHAR(7),
    overlay_opacity DECIMAL(3,2) DEFAULT 0.5,
    animation_effect VARCHAR(50),
    is_active BOOLEAN DEFAULT TRUE,
    page_slug VARCHAR(255) DEFAULT 'home',
    order_position INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_page_slug (page_slug),
    INDEX idx_active (is_active),
    INDEX idx_order_position (order_position)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create media library table
CREATE TABLE media_library (
    id INT AUTO_INCREMENT PRIMARY KEY,
    filename VARCHAR(255) NOT NULL,
    original_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_type VARCHAR(100),
    file_size INT,
    mime_type VARCHAR(100),
    alt_text VARCHAR(255),
    title VARCHAR(255),
    uploaded_by INT,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (uploaded_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_file_type (file_type),
    INDEX idx_uploaded_at (uploaded_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default site settings
INSERT INTO site_settings (setting_key, setting_value, setting_type, is_public) VALUES
('site_name', 'Study Abroad Agency', 'string', TRUE),
('site_description', 'Your trusted partner for international education', 'string', TRUE),
('contact_email', 'info@studyabroad.com', 'string', TRUE),
('contact_phone', '+1 (555) 123-4567', 'string', TRUE),
('contact_address', '123 Study Abroad Street, City, Country', 'string', TRUE),
('social_facebook', '', 'string', TRUE),
('social_twitter', '', 'string', TRUE),
('social_instagram', '', 'string', TRUE),
('social_linkedin', '', 'string', TRUE),
('social_youtube', '', 'string', TRUE),
('google_analytics_id', '', 'string', FALSE),
('facebook_pixel_id', '', 'string', FALSE),
('maintenance_mode', 'false', 'boolean', FALSE),
('registration_enabled', 'true', 'boolean', FALSE),
('default_language', 'en', 'string', FALSE),
('default_timezone', 'UTC', 'string', FALSE),
('smtp_host', 'smtp.gmail.com', 'string', FALSE),
('smtp_port', '587', 'number', FALSE),
('smtp_username', '', 'string', FALSE),
('smtp_password', '', 'string', FALSE),
('smtp_encryption', 'tls', 'string', FALSE);

-- Insert default branding config
INSERT INTO branding_config (main_logo, favicon, admin_logo, primary_color, secondary_color, accent_color, font_family) VALUES
(NULL, NULL, NULL, '#3B82F6', '#64748B', '#EAB308', 'Inter');

-- Insert default hero section
INSERT INTO hero_sections (title, subtitle, cta_text, cta_link, is_active, page_slug) VALUES
('Your Gateway to Global Education', 'Discover world-class universities and unlock your potential with our comprehensive study abroad services.', 'Get Started Today', '/contact', TRUE, 'home');