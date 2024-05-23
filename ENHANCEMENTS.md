## Future Enhancements

* Accept a config for format.
  * Table Format (default)
  * JSON Format
  * YAML Format
  * CSV Format
  * HTML Format
  * Markdown Format

* Use RubyGems API to get gem information.
  * Should show current version, available version, and latest version.
  * Hyperlink the gem name to RubyGems.

* Accept path to Gemfile/Gemfile.lock.
  * This should be the default behavior
  * We could bundle up the Gemfile/Gemfile.lock and pass it to the script
    * Probably better to parse Gemfile/Gemfile.lock and refer to Rubygems info.
  * Support URLs to Gemfile/Gemfile.lock

* Accept a config for output.
  * Standard Output + Clipboard (default)
  * Clipboard
  * File
  * Slack

