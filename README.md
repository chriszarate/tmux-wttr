# Tmux Weather (wttr.in)

This `tmux` plugin allow you to put weather information from [wttr.in][wttr] in
your status bar. It lowercases the output and strips the Fahrenheit/Celsius
indicator, because that’s the way I like it.


## Usage

Add `#{wttr}` to your `status-left` or `status-right`:

```
set-option -g status-right '#{wttr} %a %Y-%m-%d %H:%M'
```


## Installation

1. Install [Tmux Plugin Manager][tpm].

2. Add this plugin to your `~/.tmux.conf`:

```
set-option -g @plugin 'chriszarate/tmux-wttr'
```

3. Press [prefix] + `I` to install.


## Configuration

Customize what information is displayed with the `@wttr_format` option:

```
set-option -g @wttr_format '%C+%t'
```

Results are cached for 15 minutes by default. Adjust the cache window with
`@wttr_cache_ttl`:

```
set-option -g @wttr_cache_ttl 900
```

[wttr]: https://wttr.in
[tpm]: https://github.com/tmux-plugins/tpm
