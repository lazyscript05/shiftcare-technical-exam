
---

# Shiftcare Client Manager (Exam)

Shiftcare Client Manager is a Ruby on Rails application designed to streamline the management of client information. Note: This is for exam purposes only. 😊

## Prerequisites
[![Ruby Style Guide](https://img.shields.io/badge/Ruby-3.3.5-red)](https://www.ruby-lang.org/en/news/2024/09/03/3-3-5-released/)
[![Ruby Style Guide](https://img.shields.io/badge/Rails-7.2.1-brightgreen)](https://rubygems.org/gems/rails)

## Features

- **Offline Capability**: Thanks to PWA technology, the app works offline or on low-quality networks.
- **Responsive Design**: Adapts to various screen sizes, from mobile phones to desktops.
- **Installable**: Users can install the app on their home screens for quick access.
- **CLI**: Can be run from the console with the following command:
  ```bash
  rake management_system:cli
  ```

## Setup

### Install Ruby

Ensure Ruby is installed on your system. You can download Ruby from the [official Ruby website](https://www.ruby-lang.org/en/downloads/) or use a version manager like [rbenv](https://github.com/rbenv/rbenv) or [rvm](https://rvm.io/).

### First-Time Setup

1. **Install Ruby**.
2. **Download and install PostgreSQL**: [PostgreSQL Downloads](https://www.postgresql.org/download).
3. **Install RubyMine**: [RubyMine Download](https://www.jetbrains.com/ruby/download/#section=windows).
4. **Install Rails**:
   ```bash
   gem install rails
   ```

### Database and Master Key

Request the `master.key` file necessary for local setup.

## Running the App on localhost

1. **Clone the repository** or pull the main branch:
   ```bash
   git clone <repository-url>
   cd ShiftCare-Challenge-CLI-Application
   ```
2. **Install dependencies**:
   ```bash
   bundle install
   ```
3. **Database Setup**: Create, migrate, and seed the database:
   ```bash
   rake db:create
   rake db:migrate
   rake db:seed
   ```
4. **Start the server**: Run the application on localhost:
   ```bash
   rails s
   ```
   Optionally, in RubyMine, you can press the play button or use `SHIFT + F10`. Configure the server to run on port `3000` if needed.

## Using the CLI

To interact with the CLI, use the following command:
```bash
rake management_system:cli
```
You will be presented with a menu with the following options:

1. **Search by a field**: Search based on a specific field.
2. **Find data with duplicate values**: Identify duplicate values in a field.
3. **Exit**: Exit the CLI application.

Follow the prompts to make your selection and enter any required information.

## Running Tests

To run RSpec tests, navigate to the root directory of your project and execute:
```bash
rspec
```

## Code Signature

This code and documentation were developed by Cris Joseph Nahine.

## License

This application is provided as-is without any warranty. Feel free to modify and use it as needed.

---