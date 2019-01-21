#!/bin/bash
#
# Applies the theme configs
# - konsole theme and setup
# - Global shortcuts
# - Screen locking setup
# - UI Fonts
# - Dolphin setup
# - Gwenview setup
# - Kwin setups
# - Papirus icon theme
# - Kwin YAML effect
#

CONFIG_PATH="$HOME/.config"
LOCAL_SH_PATH="$HOME/.local/share"

BKP_PATH="./backups"
BKP_CONFIG_PATH="$BKP_PATH/config"
BKP_LOCAL_SH_PATH="$BKP_PATH/local/share"

function _bkp_config_file {
    if [ ! -d "$BKP_CONFIG_PATH" ]; then
        mkdir -p "$BKP_CONFIG_PATH"
    fi

    origin="$CONFIG_PATH/$1"
    target="$BKP_CONFIG_PATH/$1"
    if [ -f "$origin" ]; then
        echo "Backing up $origin to $target"
        cp $origin $target
    else
        echo "$1 file not found in $CONFIG_PATH"
    fi
}

function _rest_config_file {
    origin="$BKP_CONFIG_PATH/$1"
    target="$CONFIG_PATH/$1"

    if [ -f "$origin" ]; then
        echo "Restoring $origin to $target"
        cp "$origin" "$target"
    else
        echo "$1 file not found on $BKP_CONFIG_PATH"
    fi
}

#
# If file exists in config backups dir, restore it to
# user's config dir, otherwise, if file exists in
# users config dir, backup it to backups dir
function _rest_or_bkp_config {
    if [ -f "$BKP_CONFIG_PATH/$1" ]; then
        _rest_config_file $1
    else
        if [ -f "$CONFIG_PATH/$1" ]; then
            _bkp_config_file $1
        fi
    fi
}

function _bkp_local_sh_file {
    if [ ! -d "$BKP_LOCAL_SH_PATH" ]; then
        mkdir -p "$BKP_LOCAL_SH_PATH"
    fi

    if [ ! -d "$BKP_LOCAL_SH_PATH/kxmlgui5/dolphin" ]; then
        mkdir -p "$BKP_LOCAL_SH_PATH/kxmlgui5/dolphin"
    fi

    origin="$LOCAL_SH_PATH/$1"
    target="$BKP_LOCAL_SH_PATH/$1"
    if [ -f "$origin" ]; then
        echo "Backing up $origin to $target"
        cp $origin $target
    else
        echo "$1 file not found in $LOCAL_SH_PATH"
    fi
}

function _rest_local_sh_file {
    origin="$BKP_LOCAL_SH_PATH/$1"
    target="$LOCAL_SH_PATH/$1"

    if [ -f "$origin" ]; then
        echo "Restoring $origin to $target"
        cp "$origin" "$target"
    else
        echo "$1 file not found in $BKP_LOCAL_SH_PATH"
    fi
}

#
# If file exists in local/share backups dir, restore it to
# user's local/share dir, otherwise if file exists in
# user's /local/share dir then backup to backups dir
function _rest_or_bkp_local_sh {
    if [ -f "$BKP_LOCAL_SH_PATH/$1" ]; then
        _rest_local_sh_file $1
    else
        if [ -f "$LOCAL_SH_PATH/$1" ]; then
            _bkp_local_sh_file $1
        fi
    fi
} 

function _konsolerc {
    _rest_or_bkp_config konsolerc

    kwriteconfig5 --file konsolerc --group "DownloadDialog Settings" --key "Height 1080" 684
    kwriteconfig5 --file konsolerc --group "DownloadDialog Settings" --key "Width 1920" 936

    kwriteconfig5 --file konsolerc --group KonsoleWindow --key AllowMenuAccelerators true
    kwriteconfig5 --file konsolerc --group KonsoleWindow --key ShowAppNameOnTitleBar false
    kwriteconfig5 --file konsolerc --group KonsoleWindow --key ShowMenuBarByDefault false

    kwriteconfig5 --file konsolerc --group MainWindow --key "Height 1080" 898
    kwriteconfig5 --file konsolerc --group MainWindow --key "Width 1920" 958
    kwriteconfig5 --file konsolerc --group MainWindow --key MenuBar Disabled
    kwriteconfig5 --file konsolerc --group MainWindow --key ToolBarsMovable Disabled

    kwriteconfig5 --file konsolerc --group TabBar --key ShowQuickButtons true
    kwriteconfig5 --file konsolerc --group TabBar --key TabBarPosition Top
    kwriteconfig5 --file konsolerc --group TabBar --key TabBarVisibility ShowTabBarWhenNeeded
}

function _konsole_profile {
    scheme="./local/share/konsole/MonaLisa.colorscheme"
    profile="./local/share/konsole/MinimalClassic.profile"

    cp "$scheme" "$HOME/.local/share/konsole/"
    cp "$profile" "$HOME/.local/share/konsole/"

    kwriteconfig5 --file konsolerc --group "Desktop Entry" --key DefaultProfile MinimalClassic.profile
    kwriteconfig5 --file konsolerc --group "Favorite Profiles" --key Favorites MinimalClassic.profile
}

function _konsole {
    printf "\nSetting up konsole\n"
    _konsolerc
    _konsole_profile
}

function _global_shortcuts {
    printf "\nSetting up global shortcuts\n"
    _rest_or_bkp_config kglobalshortcutsrc

    kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Window Quick Tile Bottom" "none,none,Quick Tile Window to the Bottom"
    kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Window Quick Tile Top" "none,none,Quick Tile Window to the Top"
    kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Switch Window Up" "Meta+Alt+Up,Meta+Alt+Up,Switch to Window Above"

    kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Window Maximize" "Meta+Up,Meta+PgUp,Maximize Window"
    kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Window Maximize Vertical" "Meta+Alt+Up,none,Maximize Window Vertically"
    kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Window Minimize" "Meta+Down,Meta+PgDown,Minimize Window"
    
    kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Switch to Next Desktop" "Ctrl+Alt+Right,none,Switch to Next Desktop"
    kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Switch to Previous Desktop" "Ctrl+Alt+Left,none,Switch to Previous Desktop"

    kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Window One Desktop Down" "Ctrl+Alt+Shift+Down,none,Window One Desktop Down"
    kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Window One Desktop Up" "Ctrl+Alt+Shift+Up,none,Window One Desktop Up"
    kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Window One Desktop to the Left" "Ctrl+Alt+Shift+Left,none,Window One Desktop to the Left"
    kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Window One Desktop to the Right" "Ctrl+Alt+Shift+Right,none,Window One Desktop to the Right"

    kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "view_actual_size" "Meta+0,Meta+0,Actual Size"
    kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "view_zoom_in" "Meta+=,Meta+=,Zoom In"
    kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "view_zoom_out" "Meta+-,Meta+-,Zoom Out"
}

function _screen_locking {
    printf "\nSetting up screen locking\n"
    _rest_or_bkp_config kscreenlockerrc
    kwriteconfig5 --file kscreenlockerrc --group Daemon --key Timeout 45
}

function _setup_fonts {
    printf "\nSetting up fonts for your system UIs\n"
    _rest_or_bkp_config kdeglobals
    
    kwriteconfig5 --file kdeglobals --group General --key font "Ubuntu,12,-1,5,50,0,0,0,0,0,Regular"
    kwriteconfig5 --file kdeglobals --group General --key fixed "Hack [simp],11,-1,5,50,0,0,0,0,0,Regular"
    kwriteconfig5 --file kdeglobals --group General --key smallestReadableFont "Roboto,11,-1,5,50,0,0,0,0,0,Regular"
    kwriteconfig5 --file kdeglobals --group General --key toolBarFont "Ubuntu,12,-1,5,50,0,0,0,0,0,Regular"
    kwriteconfig5 --file kdeglobals --group General --key menuFont "Ubuntu,12,-1,5,50,0,0,0,0,0,Regular"
    kwriteconfig5 --file kdeglobals --group WM --key activeFont "Ubuntu,12,-1,5,50,0,0,0,0,0,Regular"
}

function _dolphin_rc {
    printf "\nSetting up dolphin layouts\n"
    _rest_or_bkp_config dolphinrc

    kwriteconfig5 --file dolphinrc --group CompactMode --key fontWeight 50
    kwriteconfig5 --file dolphinrc --group CompactMode --key MaximumTextWidthIndex 2
    kwriteconfig5 --file dolphinrc --group CompactMode --key PreviewSize 22

    kwriteconfig5 --file dolphinrc --group "Desktop Entry" --key DefaultProfile MinimalClassic.profile

    kwriteconfig5 --file dolphinrc --group DetailsMode --key FontWeight 50

    kwriteconfig5 --file dolphinrc --group FileMetaDataConfigurationDialog --key "Height 1080" 308
    kwriteconfig5 --file dolphinrc --group FileMetaDataConfigurationDialog --key "Width 1920" 419

    kwriteconfig5 --file dolphinrc --group General --key BrowseThroughArchives true
    kwriteconfig5 --file dolphinrc --group General --key ShowSelectionToggle false
    kwriteconfig5 --file dolphinrc --group General --key Version 200
    kwriteconfig5 --file dolphinrc --group General --key ViewPropsTimestamp "2018,4,6,21,11,20"

    kwriteconfig5 --file dolphinrc --group IconsMode --key FontWeight 50
    kwriteconfig5 --file dolphinrc --group IconsMode --key IconSize 80
    kwriteconfig5 --file dolphinrc --group IconsMode --key MaximumTextLines 1
    kwriteconfig5 --file dolphinrc --group IconsMode --key PreviewSize 80

    kwriteconfig5 --file dolphinrc --group InformationPanel --key dateFormat ShortFormat

    kwriteconfig5 --file dolphinrc --group KPropertiesDialog --key "Height 1080" 540
    kwriteconfig5 --file dolphinrc --group KPropertiesDialog --key "Width 1920" 513

    kwriteconfig5 --file dolphinrc --group MainWindow --key "Height 1080" 665
    kwriteconfig5 --file dolphinrc --group MainWindow --key "Width 1920" 1034
    kwriteconfig5 --file dolphinrc --group MainWindow --key MenuBar Disabled
    kwriteconfig5 --file dolphinrc --group MainWindow --key ToolBarsMovable Disabled

    kwriteconfig5 --file dolphinrc --group MainWindow --group "Toolbar mainToolBar" --key IconSize 24
    kwriteconfig5 --file dolphinrc --group MainWindow --group "Toolbar mainToolBar" --key ToolButtonStyle IconOnly

    kwriteconfig5 --file dolphinrc --group "Open-with settings" --key CompletionMode 1

    kwriteconfig5 --file dolphinrc --group PlacesPanel --key IconSize 16

    kwriteconfig5 --file dolphinrc --group PreviewSettings --key Plugins "directorythumbnail,imagethumbnail,jpegthumbnail,svgthumbnail"

    kwriteconfig5 --file dolphinrc --group SettingsDialog --key "Height 1080" 458
    kwriteconfig5 --file dolphinrc --group SettingsDialog --key "Width 1920" 630

    kwriteconfig5 --file dolphinrc --group "Toolbar mainToolBar" --key IconSize 24
    kwriteconfig5 --file dolphinrc --group "Toolbar mainToolBar" --key ToolButtonStyle IconOnly

    kwriteconfig5 --file dolphinrc --group ViewPropertiesDialog "Height 1080" 466
    kwriteconfig5 --file dolphinrc --group ViewPropertiesDialog "Width 1920" 419
}

function _dolphin_user_places {
    printf "\nSetting up dolphin places\n"
    _rest_or_bkp_local_sh user-places.xbel

    user_places="./local/share/user-places.xbel"
    cp "$user_places" "$LOCAL_SH_PATH/"
}

function _dolphin_toolbars_items {
    printf "\nSetting up dolphin toolbars and menus items\n"
    _rest_or_bkp_local_sh kxmlgui5/dolphin/dolphinui.rc

    dolphin_ui_file="./local/share/kxmlgui5/dolphin/dolphinui.rc"
    cp "$dolphin_ui_file" "$LOCAL_SH_PATH/kxmlgui5/dolphin/dolphinui.rc"
}

function _dolphin {
    _dolphin_rc
    _dolphin_user_places
    _dolphin_toolbars_items
}

function _gwenview {
    printf "\nSetting up Gwenview\n"
    _rest_or_bkp_config gwenviewrc

    kwriteconfig5 --file gwenviewrc --group General --key SideBarPage folders

    kwriteconfig5 --file gwenviewrc --group ImageView --key ThumbnailSplitterSizes "628,179"

    kwriteconfig5 --file gwenviewrc --group MainWindow --key "Height 1080" 843
    kwriteconfig5 --file gwenviewrc --group MainWindow --key MenuBar Disabled
    kwriteconfig5 --file gwenviewrc --group MainWindow --key ToolBarsMovable Disabled
    kwriteconfig5 --file gwenviewrc --group MainWindow --key "Width 1920" 1227

    kwriteconfig5 --file gwenviewrc --group "Phonon::AudioOutput" --key "Gwenview_Volume" 1

    kwriteconfig5 --file gwenviewrc --group Print --key PrintHeight 20

    kwriteconfig5 --file gwenviewrc --group SemanticInfoDialog --key "Height 1080" 292
    kwriteconfig5 --file gwenviewrc --group SemanticInfoDialog --key "Width 1920" 284

    kwriteconfig5 --file gwenviewrc --group SideBar --key "IsVisible BrowseMode" false
    kwriteconfig5 --file gwenviewrc --group SideBar --key "IsVisible ViewMode" false
    kwriteconfig5 --file gwenviewrc --group SideBar --key SideBarSplitterSizes "242,1131"

    kwriteconfig5 --file gwenviewrc --group StatusBar --key "IsVisible BrowseMode" false
    kwriteconfig5 --file gwenviewrc --group StatusBar --key "IsVisible ViewMode" false

    kwriteconfig5 --file gwenviewrc --group ThumbnailView --key ThumbnailSize 256
}

function _kwin {
    printf "\nSetting up Kwin\n"
    _rest_or_bkp_config kwinrc

    kwriteconfig5 --file kwinrc --group Desktops --key Number 4
    kwriteconfig5 --file kwinrc --group Desktops --key Rows 2

    kwriteconfig5 --file kwinrc --group Effect-Blur --key BlurStrength 6

    kwriteconfig5 --file kwinrc --group Plugins --key blurEnabled true
    kwriteconfig5 --file kwinrc --group Plugins --key coverswitchEnabled true
    kwriteconfig5 --file kwinrc --group Plugins --key cubeslideEnabled false
    kwriteconfig5 --file kwinrc --group Plugins --key desktopchangeosdEnabled false
    kwriteconfig5 --file kwinrc --group Plugins --key flipswitchEnabled true
    kwriteconfig5 --file kwinrc --group Plugins --key highlightwindowEnabled true
    kwriteconfig5 --file kwinrc --group Plugins --key kwin4_effect_fadedesktopEnabled false
    kwriteconfig5 --file kwinrc --group Plugins --key kwin4_effect_yetanothermagiclampEnabled true
    kwriteconfig5 --file kwinrc --group Plugins --key minimizeanimationEnabled false
    kwriteconfig5 --file kwinrc --group Plugins --key slideEnabled true
    kwriteconfig5 --file kwinrc --group Plugins --key windowgeometryEnabled false
    kwriteconfig5 --file kwinrc --group Plugins --key wobblywindowsEnabled true

    kwriteconfig5 --file kwinrc --group org.kde.kdecoration2 --key BorderSize Normal
    kwriteconfig5 --file kwinrc --group org.kde.kdecoration2 --key ButtonsOnLeft F
    kwriteconfig5 --file kwinrc --group org.kde.kdecoration2 --key ButtonsOnRight IX
    kwriteconfig5 --file kwinrc --group org.kde.kdecoration2 --key CloseOnDoubleClickOnMenu false
}

function _icons {
    printf "\nSetting up icons theme 'Papirus'\n"

    kwriteconfig5 --file kdeglobals --group Icons --key Them Papirus
}

_dependencies
_konsole
_global_shortcuts
_screen_locking
_setup_fonts
_dolphin
_gwenview
_kwin
_icons
