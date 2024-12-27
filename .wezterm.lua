local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- https://wezfurlong.org/wezterm/colorschemes/a/index.html
local schemes = {
  dark = {
    apprentice = 'Apprentice (Gogh)',
    arthur = 'Arthur (Gogh)',
    -- Black Metal themes are pretty cool, but I want an actual green
    classic_dark = 'Classic Dark (base16)',
    darkmatrix = 'darkmatrix',
    darkmoss = 'darkmoss (base16)',
    edge_dark = 'Edge Dark (base16)',
    eighties_dark = 'Eighties (dark) (base16)',
    embers_dark = 'Embers (dark) (terminal.sexy)',
    github_dark = 'Github Dark (Gogh)',
    gruvbox_dark = 'Gruvbox Dark (Gogh)',
    gruvbox_dark_hard = 'Gruvbox dark, hard (base16)',
    gruvbox_material = 'Gruvbox Material (Gogh)',
    hacktober = 'Hacktober',
    horizon_dark = 'Horizon Dark (Gogh)',
    hund = 'hund (terminal.sexy)',
    hybrid = 'Hybrid (Gogh)',
    iceberg = 'Iceberg (Gogh)',
    insignificato = 'Insignificato (terminal.sexy)',
    japanesque = 'Japanesque (Gogh)',
    kanagawa = 'Kanagawa (Gogh)',
    kanagawa_dragoon = 'Kanagawa Dragon (Gogh)',
    kurokula = 'kurokula',
    later_this_evening = 'Later This Evening (Gogh)',
    londontube_dark = 'Londontube (dark) (terminal.sexy)',
    material_darker = 'MaterialDarker',
    matrix = 'matrix',
    mikado = 'Mikado (terminal.sexy)',
    monokai = 'Monokai (base16)',
    n0tch2k = 'N0Tch2K (Gogh)',
    neobones_dark = 'neobones_dark',
    neutron = 'Neutron (Gogh)',
    nord = 'Nord (Gogh)',
    ocean = 'Ocean (base16)',
    one_half_black = 'One Half Black (Gogh)',
    -- interesting one, no red/green though
    panels = 'Panels (terminal.sexy)',
    pulp = 'Pulp (terminal.sexy)',
    rydgel = 'Rydgel (terminal.sexy)',
    seashells = 'Sea Shells (Gogh)',
    seafoam_pastel = 'Seafoam Pastel (Gogh)',
    seoul256 = 'Seoul256 (Gogh)',
    sonokai = 'Sonokai (Gogh)',
    spacedust = 'Spacedust (Gogh)',
    subliminal = 'Subliminal',
    swayr = 'Swayr (terminal.sexy)',
    sweet_love = 'Sweet Love (terminal.sexy)',
    terafox = 'terafox',
    terminix_dark = 'Terminix Dark (Gogh)',
    tokyonight = 'tokyonight',
    tomorrow_dark = 'Tomorrow (dark) (terminal.sexy)',
    tomorrow_night = 'Tomorrow Night',
    tomorrow_night_bright = 'Tomorrow Night Bright',
    twilight = 'Twilight (base16)',
    ultradark = 'UltraDark',
    vacuous_2 = 'Vacuous 2 (terminal.sexy)',
    vesper = 'Vesper',
    visibone = 'VisiBone (terminal.sexy)',
    vs_code_dark_plus = 'Vs Code Dark+ (Gogh)',
    wilmersdorf = 'wilmersdorf',
    zenbones_dark = 'zenbones_dark',
    zenwritten_dark = 'zenwritten_dark',
  },

  grey = {
    everforest_dark = 'Everforest Dark (Gogh)',
    low_contrast = 'Low Contrast (terminal.sexy)',
    lunaria_dark = 'Lunaria Dark (Gogh)',
    nova = 'Nova (base16)',
    pali = 'Pali (Gogh)',
    relaxed = 'Relaxed',
    ryuuko = 'Ryuuko',
    seoulbones_dark = 'seoulbones_dark',
    spacegray = 'SpaceGray',
    visibone_alt_2 = 'Visibone Alt. 2 (terminal.sexy)',
    wzoreck = 'Wzoreck (Gogh)',
    zenburn = 'Zenburn',
    zenburned = 'zenburned',
  },

  light = {
    atelier_plateau_light = 'Atelier Plateau Light (base16)',
    classic_light = 'Classic Light (base16)',
    cupcake = 'Cupcake (base16)',
    edge_light = 'Edge Light (base16)',
    eighties_light = 'Eighties (light) (base16)',
    embers_light = 'Embers (light) (terminal.sexy)',
    everforest_light = 'Everforest Light (Gogh)',
    github_light = 'Github Light (Gogh)',
    gruvbox_light = 'Gruvbox (Gogh)',
    horizon_light = 'Horizon Light (base16)',
    iceberg_light = 'iceberg-light',
    londontube_light = 'Londontube (light) (terminal.sexy)',
    lunaria_light = 'Lunaria Light (Gogh)',
    material = 'Material',
    material_lighter = 'Material Lighter (base16)',
    mexico_light = 'Mexico Light (base16)',
    mocha_light = 'Mocha (light) (terminal.sexy)',
    monokai_light = 'Monokai (light) (terminal.sexy)',
    mostly_bright = 'Mostly Bright (terminal.sexy)',
    neobones_light = 'neobones_light',
    night_owlish_light = 'Night Owlish Light',
    nord_light = 'nord-light',
    ocean_light = 'Ocean (light) (terminal.sexy)',
    one_light = 'One Light (base16)',
    one_half_light = 'OneHalfLight',
    papercolor_light = 'Papercolor Light (Gogh)',
    piatto_light = 'Piatto Light',
    primary = 'primary',
    railscasts_light = 'Railscasts (light) (terminal.sexy)',
    rose_pine_dawn = 'rose-pine-dawn',
    rose_pine_dawn_gogh = 'Rosé Pine Dawn (Gogh)',
    sagelight = 'Sagelight (base16)',
    sakura = 'Sakura (base16)',
    seoul256_light = 'Seoul256 Light (Gogh)',
    seoulbones_light = 'seoulbones_light',
    silk_light = 'Silk Light (base16)',
    tokyo_night_day = 'Tokyo Night Day',
    tokyo_night_light = 'Tokyo Night Light (Gogh)',
    tomorrow = 'Tomorrow',
    tomorrow_light = 'Tomorrow (light) (terminal.sexy)',
    twilight_light = 'Twilight (light) (terminal.sexy)',
    zenbones = 'zenbones',
    zenwritten_light = 'zenwritten_light',
  },

  sepia = {
    belafonte_day = 'Belafonte Day (Gogh)',
    mocha = 'Mocha (base16)',
    novel = 'Novel (Gogh)',
    paper = 'Paper (Gogh)',
    paraiso_light = 'Paraiso (light) (terminal.sexy)',
    solarized_light = 'Solarized Light (Gogh)',
    vimbones = 'vimbones',
    yousai = 'Yousai (terminal.sexy)',
  },

  other = {
    grass = 'Grass (Gogh)',
    greenscreen_dark = 'Greenscreen (dark) (terminal.sexy)',
    greenscreen_light = 'Greenscreen (light) (terminal.sexy)',
    spiderman = 'Spiderman',
    vulcan = 'vulcan (base16)',
  },

}

-- RANDOM SCHEME
local function random_scheme()
  local appearance = wezterm.gui.get_appearance()
  local category
  if appearance:find("Dark") then
    category = math.random() < 0.5 and 'dark' or 'grey'
  else
    category = math.random() < 0.5 and 'light' or 'sepia'
  end
  local category_schemes = {}
  for _, scheme in pairs(schemes[category]) do
    table.insert(category_schemes, scheme)
  end
  return category_schemes[math.random(#category_schemes)]
end


-- OVERRIDE SCHEME
local color_scheme = schemes.dark.kanagawa
-- local color_scheme = nil
local color_scheme = color_scheme or random_scheme()
print(color_scheme)
assert(color_scheme ~= nil, "Scheme not found")
config.color_scheme = color_scheme

config.font = wezterm.font_with_fallback {
  'Monaspace Neon',
  'JetBrains Mono',
}



return config
