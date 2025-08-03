-- Create pages table
CREATE TABLE pages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    slug VARCHAR(255) NOT NULL UNIQUE,
    title VARCHAR(255) NOT NULL,
    content LONGTEXT,
    meta_title VARCHAR(255),
    meta_description TEXT,
    meta_keywords TEXT,
    status ENUM('draft', 'published', 'archived') DEFAULT 'draft',
    featured_image VARCHAR(500),
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_slug (slug),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create countries table
CREATE TABLE countries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    image VARCHAR(500),
    universities_count INT DEFAULT 0,
    is_featured BOOLEAN DEFAULT FALSE,
    meta_title VARCHAR(255),
    meta_description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_slug (slug),
    INDEX idx_featured (is_featured)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create universities table
CREATE TABLE universities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    country_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    programs TEXT,
    requirements TEXT,
    logo VARCHAR(500),
    website VARCHAR(255),
    ranking INT,
    tuition_fee_min DECIMAL(10,2),
    tuition_fee_max DECIMAL(10,2),
    application_deadline DATE,
    is_featured BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (country_id) REFERENCES countries(id) ON DELETE CASCADE,
    INDEX idx_country_id (country_id),
    INDEX idx_slug (slug),
    INDEX idx_featured (is_featured)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create services table
CREATE TABLE services (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    icon VARCHAR(100),
    price DECIMAL(10,2),
    is_featured BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_slug (slug),
    INDEX idx_featured (is_featured)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create homepage sections table
CREATE TABLE homepage_sections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    section_type ENUM('hero', 'services', 'countries', 'testimonials', 'statistics', 'team', 'newsletter', 'custom') NOT NULL,
    title VARCHAR(255),
    subtitle TEXT,
    content JSON,
    order_position INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_section_type (section_type),
    INDEX idx_order_position (order_position),
    INDEX idx_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create team members table
CREATE TABLE team_members (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    position VARCHAR(100),
    photo VARCHAR(500),
    bio TEXT,
    social_links JSON,
    order_position INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_order_position (order_position),
    INDEX idx_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create testimonials table
CREATE TABLE testimonials (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    photo VARCHAR(500),
    content TEXT NOT NULL,
    country VARCHAR(50),
    university VARCHAR(255),
    rating INT CHECK (rating >= 1 AND rating <= 5),
    is_featured BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_featured (is_featured),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default countries
INSERT INTO countries (name, slug, description, is_featured) VALUES
('Germany', 'germany', 'Study in Germany with world-class universities and affordable education.', TRUE),
('Canada', 'canada', 'Experience high-quality education in a multicultural environment.', TRUE),
('Turkey', 'turkey', 'Discover unique opportunities in Turkish universities.', FALSE),
('China', 'china', 'Explore educational opportunities in rapidly growing China.', FALSE),
('United States', 'usa', 'Study at prestigious American universities.', TRUE),
('Australia', 'australia', 'Experience world-class education in beautiful Australia.', TRUE),
('United Kingdom', 'uk', 'Study at historic and prestigious British institutions.', TRUE),
('Netherlands', 'netherlands', 'Innovative education in the heart of Europe.', FALSE);

-- Insert default services
INSERT INTO services (name, slug, description, icon, price, is_featured) VALUES
('University Application Assistance', 'university-application', 'Complete support for university applications including document preparation and submission.', 'graduation-cap', 500.00, TRUE),
('Visa Consultation', 'visa-consultation', 'Expert guidance for student visa applications and requirements.', 'passport', 300.00, TRUE),
('Scholarship Guidance', 'scholarship-guidance', 'Help finding and applying for scholarships and financial aid.', 'award', 200.00, TRUE),
('Accommodation Services', 'accommodation-services', 'Assistance finding suitable accommodation near your university.', 'home', 150.00, FALSE),
('Pre-departure Orientation', 'pre-departure-orientation', 'Comprehensive orientation to prepare you for studying abroad.', 'plane', 100.00, FALSE),
('Language Training', 'language-training', 'Language courses to prepare for your study abroad experience.', 'book-open', 250.00, FALSE);