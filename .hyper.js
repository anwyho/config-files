// Future versions of Hyper may add additional config options,
// which will not automatically be merged into this file.
// See https://hyper.is#cfg for all currently supported options.
module.exports = {
  config: {
    updateChannel: 'stable',
    fontSize: 11,
    fontFamily: 'Menlo, "DejaVu Sans Mono", Consolas, "Lucida Console", monospace',
    fontWeight: 'normal',
    fontWeightBold: 'bold',
    lineHeight: 1, // rem
    letterSpacing: 0, // rem
    // terminal cursor background color and opacity (hex, rgb, hsl, hsv, hwb or cmyk)
    cursorColor: 'rgba(248,28,229,0.8)',
    // terminal text color under BLOCK cursor
    cursorAccentColor: '#000',
    // `'BEAM'` for |, `'UNDERLINE'` for _, `'BLOCK'` for █
    cursorShape: 'BLOCK',
    cursorBlink: true,
    foregroundColor: '#fff',
    // opacity is only supported on macOS
    // backgroundColor: '#000',
    backgroundColor: 'rgba(0,0,0,0.9)',
    selectionColor: 'rgba(248,28,229,0.3)',
    borderColor: '#333',
    padding: '8px 14px 20px 14px',  // top right bottom left
    colors: {
      black: '#000000',
      red: '#C51E14',
      green: '#1DC121',
      yellow: '#C7C329',
      blue: '#0A2FC4',
      magenta: '#C839C5',
      cyan: '#20C5C6',
      white: '#C7C7C7',
      lightBlack: '#686868',
      lightRed: '#FD6F6B',
      lightGreen: '#67F86F',
      lightYellow: '#FFFA72',
      lightBlue: '#6A76FB',
      lightMagenta: '#FD7CFC',
      lightCyan: '#68FDFE',
      lightWhite: '#FFFFFF',
    },
    windowSize: [680,450],
    scrollback: 10000,
    bell: 'VISUAL',
    macOptionSelectionMode: 'vertical',
    // bellSoundURL: 'http://example.com/bell.mp3',
    webGLRenderer: true,
    hyperline: {
      plugins: ['cpu', 'memory', 'network', 'spotify']
    }
  },
  plugins: [
      `hypercwd`,
      `hyperline`,
      `hyperterm-paste`,
      // `hyperborder`,
      `hyper-search`,
      `hyperlinks`,
      // `hyper-autohide-tabs`,
  ],
  keymaps: {
    // Example
    // 'window:devtools': 'cmd+alt+o',
  },
};
