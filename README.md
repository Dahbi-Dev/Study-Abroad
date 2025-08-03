# Study Abroad Agency Website

A modern, professional study abroad agency website with a comprehensive admin panel for managing all content, leads, and business operations.

## Tech Stack

- **Frontend**: HTML5, Tailwind CSS, JavaScript (ES6+)
- **Backend**: PHP 8.0+, MySQL 8.0+
- **Animations**: AOS (Animate On Scroll), Lottie animations, CSS3 transitions
- **Architecture**: MVC pattern, RESTful APIs
- **Security**: JWT tokens, input validation, CSRF protection

## Features

### Core Website Features
- ✅ Responsive homepage with customizable sections
- ✅ Country/destination pages with university listings
- ✅ Services pages with detailed information
- ✅ Dynamic forms system with drag-and-drop builder
- ✅ News & blog system with rich editor
- ✅ Advanced content sections management
- ✅ Student testimonials and success stories

### Admin Panel Features
- ✅ Multi-role authentication system
- ✅ Lead & student management
- ✅ Complete branding & customization system
- ✅ Advanced blog & news management
- ✅ Form builder & management
- ✅ Analytics dashboard
- ✅ Multi-agency features (white-label)

### Security Features
- ✅ Input sanitization and validation
- ✅ SQL injection prevention
- ✅ XSS protection
- ✅ CSRF tokens
- ✅ File upload security
- ✅ Password hashing (bcrypt)
- ✅ Role-based permissions

## Installation

1. Clone the repository
2. Set up your web server (Apache/Nginx)
3. Configure your database settings in `/src/Config/database.php`
4. Import the database schema from `/database/migrations/`
5. Set up your environment variables

## Project Structure

```
/project-root
├── /public          # Public assets and entry point
├── /src            # Application source code
├── /admin          # Admin panel
├── /api            # REST API endpoints
├── /database       # Database migrations and seeds
└── /docs           # Documentation
```

## Development

- Run `composer install` to install PHP dependencies
- Run `npm install` to install frontend dependencies
- Configure your development environment
- Start development server

## License

MIT License

