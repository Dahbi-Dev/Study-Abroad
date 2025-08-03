-- Create forms table
CREATE TABLE forms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    fields_config JSON NOT NULL,
    settings JSON,
    is_active BOOLEAN DEFAULT TRUE,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_slug (slug),
    INDEX idx_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create form submissions table
CREATE TABLE form_submissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    form_id INT NOT NULL,
    student_id INT,
    data JSON NOT NULL,
    ip_address VARCHAR(45),
    user_agent TEXT,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN DEFAULT FALSE,
    status ENUM('new', 'processing', 'completed', 'cancelled') DEFAULT 'new',
    notes TEXT,
    FOREIGN KEY (form_id) REFERENCES forms(id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE SET NULL,
    INDEX idx_form_id (form_id),
    INDEX idx_student_id (student_id),
    INDEX idx_submitted_at (submitted_at),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create form templates table
CREATE TABLE form_templates (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    fields_config JSON NOT NULL,
    settings JSON,
    is_system BOOLEAN DEFAULT FALSE,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_system (is_system)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default form templates
INSERT INTO form_templates (name, description, fields_config, settings, is_system) VALUES
('Contact Form', 'Basic contact form for general inquiries', 
'[
    {"type": "text", "name": "name", "label": "Full Name", "required": true, "placeholder": "Enter your full name"},
    {"type": "email", "name": "email", "label": "Email Address", "required": true, "placeholder": "Enter your email address"},
    {"type": "tel", "name": "phone", "label": "Phone Number", "required": false, "placeholder": "Enter your phone number"},
    {"type": "select", "name": "country_interest", "label": "Country of Interest", "required": false, "options": ["Germany", "Canada", "Turkey", "China", "USA", "Australia", "UK", "Netherlands"]},
    {"type": "textarea", "name": "message", "label": "Message", "required": true, "placeholder": "Tell us about your study abroad goals"}
]',
'{"email_notifications": true, "auto_response": true, "redirect_url": "/thank-you"}',
TRUE),

('University Application Form', 'Comprehensive form for university applications',
'[
    {"type": "text", "name": "full_name", "label": "Full Name", "required": true},
    {"type": "email", "name": "email", "label": "Email Address", "required": true},
    {"type": "tel", "name": "phone", "label": "Phone Number", "required": true},
    {"type": "date", "name": "birth_date", "label": "Date of Birth", "required": true},
    {"type": "select", "name": "country_interest", "label": "Country of Interest", "required": true, "options": ["Germany", "Canada", "Turkey", "China", "USA", "Australia", "UK", "Netherlands"]},
    {"type": "text", "name": "university_interest", "label": "Preferred University", "required": false},
    {"type": "text", "name": "program_interest", "label": "Program of Interest", "required": false},
    {"type": "select", "name": "education_level", "label": "Current Education Level", "required": true, "options": ["High School", "Bachelor", "Master", "PhD"]},
    {"type": "number", "name": "budget", "label": "Budget Range (USD)", "required": false, "placeholder": "e.g., 10000"},
    {"type": "textarea", "name": "motivation", "label": "Motivation Letter", "required": true, "placeholder": "Why do you want to study abroad?"}
]',
'{"email_notifications": true, "auto_response": true, "create_student": true, "redirect_url": "/application-received"}',
TRUE),

('Scholarship Application Form', 'Form for scholarship applications',
'[
    {"type": "text", "name": "full_name", "label": "Full Name", "required": true},
    {"type": "email", "name": "email", "label": "Email Address", "required": true},
    {"type": "tel", "name": "phone", "label": "Phone Number", "required": true},
    {"type": "select", "name": "scholarship_type", "label": "Scholarship Type", "required": true, "options": ["Merit-based", "Need-based", "Country-specific", "University-specific", "Program-specific"]},
    {"type": "select", "name": "country_interest", "label": "Country of Interest", "required": true, "options": ["Germany", "Canada", "Turkey", "China", "USA", "Australia", "UK", "Netherlands"]},
    {"type": "text", "name": "current_institution", "label": "Current Institution", "required": true},
    {"type": "number", "name": "gpa", "label": "Current GPA", "required": true, "min": 0, "max": 4, "step": 0.01},
    {"type": "textarea", "name": "achievements", "label": "Academic Achievements", "required": true},
    {"type": "textarea", "name": "financial_need", "label": "Financial Need Statement", "required": true},
    {"type": "file", "name": "transcript", "label": "Academic Transcript", "required": true, "accept": ".pdf,.doc,.docx"}
]',
'{"email_notifications": true, "auto_response": true, "create_student": true, "redirect_url": "/scholarship-application-received"}',
TRUE);