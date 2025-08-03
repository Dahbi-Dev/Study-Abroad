-- Create blog posts table
CREATE TABLE posts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE,
    content LONGTEXT,
    excerpt TEXT,
    featured_image VARCHAR(500),
    category_id INT,
    tags JSON,
    status ENUM('draft', 'published', 'archived') DEFAULT 'draft',
    scheduled_at TIMESTAMP NULL,
    views_count INT DEFAULT 0,
    is_featured BOOLEAN DEFAULT FALSE,
    is_sticky BOOLEAN DEFAULT FALSE,
    meta_title VARCHAR(255),
    meta_description TEXT,
    meta_keywords TEXT,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_slug (slug),
    INDEX idx_status (status),
    INDEX idx_featured (is_featured),
    INDEX idx_sticky (is_sticky),
    INDEX idx_created_at (created_at),
    INDEX idx_views_count (views_count)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create post categories table
CREATE TABLE post_categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    color VARCHAR(7) DEFAULT '#3B82F6',
    parent_id INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_id) REFERENCES post_categories(id) ON DELETE SET NULL,
    INDEX idx_slug (slug),
    INDEX idx_parent_id (parent_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create post tags table
CREATE TABLE post_tags (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    slug VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_slug (slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create post comments table
CREATE TABLE post_comments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    author_name VARCHAR(100) NOT NULL,
    author_email VARCHAR(255) NOT NULL,
    author_website VARCHAR(255),
    content TEXT NOT NULL,
    status ENUM('pending', 'approved', 'spam', 'rejected') DEFAULT 'pending',
    parent_id INT NULL,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
    FOREIGN KEY (parent_id) REFERENCES post_comments(id) ON DELETE CASCADE,
    INDEX idx_post_id (post_id),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default categories
INSERT INTO post_categories (name, slug, description, color) VALUES
('Study Abroad Tips', 'study-abroad-tips', 'Helpful tips and advice for studying abroad', '#3B82F6'),
('University Guides', 'university-guides', 'Comprehensive guides to universities around the world', '#10B981'),
('Visa Information', 'visa-information', 'Latest visa requirements and application tips', '#F59E0B'),
('Scholarship Opportunities', 'scholarship-opportunities', 'Information about scholarships and financial aid', '#EF4444'),
('Student Stories', 'student-stories', 'Real experiences from students studying abroad', '#8B5CF6'),
('Country Guides', 'country-guides', 'Detailed information about study destinations', '#06B6D4'),
('Application Process', 'application-process', 'Step-by-step guides for university applications', '#84CC16'),
('Pre-departure', 'pre-departure', 'Everything you need to know before leaving', '#F97316');

-- Insert default tags
INSERT INTO post_tags (name, slug) VALUES
('Germany', 'germany'),
('Canada', 'canada'),
('Turkey', 'turkey'),
('China', 'china'),
('USA', 'usa'),
('Australia', 'australia'),
('UK', 'uk'),
('Netherlands', 'netherlands'),
('Visa', 'visa'),
('Scholarship', 'scholarship'),
('Application', 'application'),
('Tips', 'tips'),
('Guide', 'guide'),
('Student Life', 'student-life'),
('Culture', 'culture'),
('Language', 'language'),
('Accommodation', 'accommodation'),
('Budget', 'budget'),
('Career', 'career'),
('Internship', 'internship');

-- Insert sample blog posts
INSERT INTO posts (title, slug, content, excerpt, category_id, tags, status, is_featured, created_by) VALUES
('Top 10 Universities in Germany for International Students', 'top-10-universities-germany', 
'<h2>Introduction</h2><p>Germany is one of the most popular destinations for international students, offering high-quality education at affordable costs. Here are the top 10 universities that attract students from around the world.</p><h2>1. Technical University of Munich</h2><p>The Technical University of Munich (TUM) is consistently ranked among the top universities in Germany and Europe. Known for its strong programs in engineering, natural sciences, and medicine, TUM offers excellent research opportunities and industry connections.</p><h2>2. Ludwig Maximilian University of Munich</h2><p>LMU Munich is one of Germany\'s oldest and most prestigious universities. It offers a wide range of programs and is particularly strong in humanities, social sciences, and medicine.</p>',
'Discover the best universities in Germany for international students, including admission requirements, programs, and student life.',
1, '["germany", "guide", "universities"]', 'published', TRUE, 1),

('Complete Guide to Student Visa for Canada', 'student-visa-canada-guide',
'<h2>Canada Student Visa Requirements</h2><p>To study in Canada, you need a study permit (student visa). Here\'s everything you need to know about the application process.</p><h2>Required Documents</h2><ul><li>Letter of acceptance from a Canadian institution</li><li>Proof of financial support</li><li>Passport and photographs</li><li>Medical examination results</li><li>Police certificate</li></ul><h2>Application Process</h2><p>The application process typically takes 4-6 weeks. You can apply online or at a visa application center.</p>',
'Everything you need to know about applying for a Canadian student visa, including requirements, documents, and application process.',
3, '["canada", "visa", "guide"]', 'published', TRUE, 1),

('Scholarship Opportunities for International Students in 2024', 'scholarship-opportunities-2024',
'<h2>Merit-based Scholarships</h2><p>Many universities offer merit-based scholarships for outstanding international students. These are typically awarded based on academic excellence, leadership qualities, and extracurricular achievements.</p><h2>Country-specific Scholarships</h2><p>Several countries offer scholarships specifically for international students. For example, Germany offers DAAD scholarships, while Canada has the Vanier CGS program.</p><h2>University-specific Scholarships</h2><p>Most universities have their own scholarship programs for international students. These may cover partial or full tuition fees.</p>',
'Discover the latest scholarship opportunities available for international students in 2024, including merit-based and country-specific programs.',
4, '["scholarship", "2024", "opportunities"]', 'published', FALSE, 1);