# Notifier App
Prototype is built with Rails 8 to deliver due date email reminders for user tickets.
Delivery time can be customized by the user including reminder time offset, exact time including the timezone.

The most interesting test file would be `test/integration/reminder_email_delivery_test.rb`, this one tests the majority of the app functionality. Have fun!

Currently, only the `email` delivery method is supported. This can easily be extended by implementing new delivery methods by adding new mappings to this method: `DueDateReminder::DispatcherJob#get_class_for`

`DueDateReminder::DispatcherJob` is scheduled to be run every day at 2:00 in development and production environments,
it uses solid queue. See `config/recurring.yml` for reference.

## Install System Dependencies (you probably already have these 🤔)

```bash
  sudo apt-get install build-essentials libyaml sqlite3
```

## Install Ruby and Project dependencies
The current app is tested with ruby `3.3.5`, though it should also work with any Rails 8 compatible version `3.2+`

```bash
git clone git@github.com:webzorg/notifier.git
cd notifier
asdf install # in case of using asdf, install ruby .tools-versions.
bundle
bin/rails test
```

## Development

If you wish to play with the development environment, running `bin/dev` also runs `mailcatcher` (check `Procfile.dev`), which is an awesome tool for debugging email deliveries. Delivered emails can be browsed by visiting `http://localhost:1080/`.

Scheduled jobs in development are run within the puma process, so running `bin/jobs` in development is not required.
