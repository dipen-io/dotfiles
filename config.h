// In this code there is not errors
// but i don't know work or not
#include <X11/X.h> // For Mod4Mask, ShiftMask, ControlMask, Mod1Mask etc.
#include <X11/XF86keysym.h> // For XF86XK_... constants
#include <X11/Xlib.h>       // For Window, Display, etc.
#include <X11/keysym.h>
#include <X11/keysymdef.h> // For XK_... constants
#include <stddef.h>        // For NULL

/* macros */
#define LENGTH(X) (sizeof X / sizeof X[0])
#define TAGMASK (~0)
#define TAGMON(i) (tagmon((const Arg *){.i = i}))
#define TAGVIEW(i) (view((const Arg *){.ui = 1 << i})) // Helper for TAGKEYS
#define MODKEY Mod1Mask

/* forward declarations */
typedef struct Client Client;
typedef struct Monitor Monitor;

/* type definitions */
typedef union {
  int i;
  unsigned int ui;
  float f;
  const void *v;
} Arg;

typedef struct {
  unsigned int mod;          // Modifier mask (Ctrl, Alt, Shift, Super, etc.)
  KeySym keysym;             // The key itself (from X11/keysymdef.h)
  void (*func)(const Arg *); // Pointer to the function to execute
  const Arg arg;             // The argument to pass to the function
} Key;

typedef struct {
  const char *symbol;
  void (*arrange)(Monitor *); // Pointer to the layout function
} Layout;

typedef struct {
  unsigned int click;           // Event type, e.g., ClkTagBar, ClkLtSymbol etc.
  unsigned int mask;            // Modifier mask
  unsigned int button;          // Mouse button (Button1, Button2, Button3)
  void (*func)(const Arg *arg); // Function to execute
  const Arg arg;                // Argument to pass
} Button;

typedef struct {
  const char *class;
  const char *instance;
  const char *title;
  unsigned int tags;
  int isfloating;
  int monitor;
} Rule;

/* Function prototypes (declarations) */
// These tell the compiler about the functions defined elsewhere or later in the
// file Add prototypes for all functions used in keys, buttons, or called
// directly

static void viewprevtag();
static void viewnexttag();
void applyrules(Client *c); // Example function prototype that might be needed
void arrange(Monitor *m);
Client *creat(Window w,
              XWindowAttributes *wa); // Example needed for window creation
Monitor *dirtomon(int dir);
Monitor *selmon;
void focusmon(const Arg *arg);
void focusstack(const Arg *arg);
Atom getatomprop(Client *c, Atom atom); // Example needed for window properties
int gettextprop(Window w, Atom atom, char *text, unsigned int size);
void killclient(const Arg *arg);
void manage(Window w,
            XWindowAttributes *wa); // Example needed for managing new windows
void monocle(Monitor *m);
void movemouse(const Arg *arg);
void quit(const Arg *arg);
void resizemouse(const Arg *arg);
void setfullscreen(Client *c, int fullscreen);
void setlayout(const Arg *arg);
void setmfact(const Arg *arg); // Example function if you add keys for mfact
void spawn(const Arg *arg);
void tag(const Arg *arg);
void tagmon(const Arg *arg);
void tile(Monitor *m);
void togglebar(const Arg *arg);
void togglefloating(const Arg *arg);
void toggletag(const Arg *arg);
void toggleview(const Arg *arg);
void unfocus(Client *c, int setfocus);   // Example function
void unmanage(Client *c, int destroyed); // Example function
void updategeometry(Client *c);          // Example function
void view(const Arg *arg);
void viewnexttag(); // Specific function prototype for your custom function
void viewprevtag(); // Specific function prototype for your custom function
void zoom(const Arg *arg);

/* struct definitions */
// Define Monitor struct (depends on Client, so forward declare Client first)
struct Monitor {
  int num;                // Monitor number
  int mx, my, mw, mh;     // screen size
  int wx, wy, ww, wh;     // window area geometry
  unsigned int tagset[2]; // array of tags for this monitor
  int seltags;            // index into tagset (0 or 1)
  Client *clients;        // list of clients on this monitor
  Client *sel;            // currently selected client on this monitor
                          // ... potentially many other members
};

// Now define Client struct (depends on Monitor and Window)
struct Client {
  Window win;        // X window ID (needs Xlib.h)
  int x, y, w, h;    // window geometry
  int isfloating;    // floating state
  int isfullscreen;  // fullscreen state
  unsigned int tags; // client tags
  Client *next;      // next client in stack
  Monitor *mon;      // monitor the client is on (needs Monitor definition)
                     // ... potentially many other members
};

/* appearance */
static const unsigned int borderpx = 1; /* border pixel of windows */
static const unsigned int snap = 32;    /* snap pixel */
static const int showbar = 1;           /* 0 means no bar */
static const int topbar = 1;            /* 0 means bottom bar */
static const char *fonts[] = {"Symbols Nerd Font:size=10", "monospace:size=10"};
static const char dmenufont[] = "monospace:size=10";
static const char col_gray1[] = "#222222";
static const char col_gray2[] = "#444444";
static const char col_gray3[] = "#bbbbbb";
static const char col_gray4[] = "#eeeeee";
static const char col_cyan[] = "#005577";

enum { SchemeNorm, SchemeSel };
static const char *colors[][3] = {
    /* fg         bg         border   */
    [SchemeNorm] = {col_gray3, col_gray1, col_gray2},
    [SchemeSel] = {col_gray4, col_cyan, col_cyan},
};

/* click defines */
enum {
  ClkTagBar,     // Tag bar area
  ClkLtSymbol,   // Layout symbol
  ClkStatusText, // Status bar text
  ClkWinTitle,   // Title area in the bar
  ClkClientWin,  // Inside client window
  ClkRootWin,    // Desktop background or root window
};

/* tagging */
static const char *tags[] = {"1", "2", "3", "4", "5",
                             "6", "7", "8", "9"}; // workspace

/* layout(s) */
static const float mfact = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster = 1;    /* number of clients in master area */
static const int resizehints =
    1; /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen =
    1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
    /* symbol      arrange function */
    {"[]=", tile}, /* first entry is default */
    {"><>", NULL}, /* no layout function means floating behavior */
    {"[M]", monocle},
};

/* rules */
static const Rule rules[] = {
    /* class      instance    title    tags mask     isfloating   monitor */
    {"Firefox", NULL, NULL, 1 << 2, 0, -1}, // Firefox in tag 3
    {"Zen", NULL, NULL, 1 << 1, 0, -1},     // Zen in tag 2
};

/* commands */
static char dmenumon[2] = "0"; // Assuming multi-monitor setup
static const char *dmenucmd[] = {
    "dmenu_run", "-m",      dmenumon, "-fn",    dmenufont, "-nb",     col_gray1,
    "-nf",       col_gray3, "-sb",    col_cyan, "-sf",     col_gray4, NULL};

// here set the terminal alacritty (or st as currently configured)
static const char *termcmd[] = {
    "st", NULL}; // Changed from {"alacritty", NULL} to match your code

// custom functions defined by the user
static void viewnexttag() {
  unsigned int newtag = selmon->tagset[selmon->seltags] << 1;
  if (newtag >= (1 << LENGTH(tags))) {
    newtag = 1;
  }
  view(&(Arg){.ui = newtag});
}

static void viewprevtag() {
  unsigned int newtag = selmon->tagset[selmon->seltags] >> 1;
  if (newtag == 0) {
    newtag = (1 << (LENGTH(tags) - 1));
  }
  view(&(Arg){.ui = newtag});
}

static void fullscreentoggle(const Arg *arg) {
  (void)arg; // Cast arg to void to suppress unused parameter warning
  setfullscreen(selmon->sel, !selmon->sel->isfullscreen);
}

/* key definitions */
#define MODKEY Mod1Mask // Use Alt as the primary modifier key

#define TAGKEYS(KEY, TAG)                                                      \
  {MODKEY, KEY, view, {.ui = 1 << TAG}},                                       \
      {MODKEY | ControlMask, KEY, toggleview, {.ui = 1 << TAG}},               \
      {MODKEY | ShiftMask, KEY, tag, {.ui = 1 << TAG}}, {                      \
    MODKEY | ControlMask | ShiftMask, KEY, toggletag, { .ui = 1 << TAG }       \
  }

// Macro to wrap shell commands for spawn
#define SHCMD(cmd)                                                             \
  {                                                                            \
    .v = (const char *[]) { "/bin/sh", "-c", cmd, NULL }                       \
  }

static const Key keys[] = {
    /* modifier                     key            function argument */

    // scripts
    // window+c open neovim config
    {Mod4Mask, XK_c, spawn, SHCMD("alacritty -e nvim ~/.config/nvim/init.lua")},
    // alt+c will execute tmux
    {MODKEY, XK_c, spawn, SHCMD("alacritty -e ~/script/python.py")},

    // maim/slop screenshot commands
    {Mod4Mask, XK_p, spawn,
     SHCMD("file=~/Desktop/ss/_$(date +'%Y-%m-%d_%H-%M-%S').png; maim -s "
           "$(slop -f '-g %g') $file && notify-send 'Screenshot Saved' $file")},

    {Mod4Mask | ShiftMask, XK_p, spawn,
     SHCMD("file=~/Desktop/ss/_$(date +'%Y-%m-%d_%H-%M-%S').png; maim $file && "
           "notify-send 'Screenshot Saved' $file")},

    // working sound (requires XF86keysym.h)
    {0, XF86XK_AudioLowerVolume, spawn,
     SHCMD("pactl set-sink-volume @DEFAULT_SINK@ -5%")},
    {0, XF86XK_AudioRaiseVolume, spawn,
     SHCMD("pactl set-sink-volume @DEFAULT_SINK@ +5%")},
    {0, XF86XK_AudioMute, spawn,
     SHCMD("pactl set-sink-mute @DEFAULT_SINK@ toggle")},

    // Increase brightness (requires XF86keysym.h)
    {0, XF86XK_MonBrightnessUp, spawn, SHCMD("brightnessctl set +5%")},

    // Decrease brightness (requires XF86keysym.h)
    {0, XF86XK_MonBrightnessDown, spawn, SHCMD("brightnessctl set 5%-")},

    // core application control
    {MODKEY, XK_d, spawn, {.v = dmenucmd}},     // open dmenu
    {MODKEY, XK_Return, spawn, {.v = termcmd}}, // open terminal
    {MODKEY, XK_q, killclient, {0}},            // Kill window
    {MODKEY | ShiftMask, XK_q, quit, {0}},      // kill session

    // window management
    {MODKEY, XK_b, togglebar, {0}},        // toggle statusbar
    {MODKEY, XK_h, focusstack, {.i = -1}}, // Left focus
    {MODKEY, XK_l, focusstack, {.i = +1}}, // Right focus
    {MODKEY, XK_f, fullscreentoggle, {0}}, // Needs fullscreentoggle prototype
    {MODKEY,
     XK_space,
     setlayout,
     {0}}, // switch => Tiles,float,monocle. Needs setlayout prototype
    {MODKEY | ShiftMask,
     XK_space,
     togglefloating,
     {0}}, // window float. Needs togglefloating prototype

    // workspace control
    {MODKEY,
     XK_j,
     viewprevtag,
     {0}}, // Prev workspace. Needs viewprevtag prototype
    {MODKEY,
     XK_k,
     viewnexttag,
     {0}}, // Next workspace. Needs viewnexttag prototype

    // lock the screen
    {Mod4Mask, XK_Return, spawn, SHCMD("xsecurelock")},

    {MODKEY,
     XK_0,
     view,
     {.ui = ~0}}, // view all open software. Needs view prototype

    // monitor control
    {MODKEY,
     XK_comma,
     focusmon,
     {.i = -1}}, // focus prev monitor. Needs focusmon prototype
    {MODKEY,
     XK_period,
     focusmon,
     {.i = +1}}, // focus next monitor. Needs focusmon prototype
    {MODKEY | ShiftMask,
     XK_comma,
     tagmon,
     {.i = -1}}, // move window to  prev monitor. Needs tagmon prototype
    {MODKEY | ShiftMask,
     XK_period,
     tagmon,
     {.i = +1}}, // window to next monitor. Needs tagmon prototype

    // Tag switching and moving using the TAGKEYS macro
    TAGKEYS(XK_1, 0),
    TAGKEYS(XK_2, 1),
    TAGKEYS(XK_3, 2),
    TAGKEYS(XK_4, 3),
    TAGKEYS(XK_5, 4),
    TAGKEYS(XK_6, 5),
    TAGKEYS(XK_7, 6),
    TAGKEYS(XK_8, 7),
    TAGKEYS(XK_9, 8)

};

/* button definitions */
// Needs Button struct definition, and prototypes for functions used
static const Button buttons[] = {
    /* click                event mask      button          function argument */
    {ClkLtSymbol, 0, Button1, setlayout, {0}}, // Needs setlayout prototype
    {ClkLtSymbol,
     0,
     Button3,
     setlayout,
     {.v = &layouts[2]}},                 // Needs setlayout prototype
    {ClkWinTitle, 0, Button2, zoom, {0}}, // Needs zoom prototype
    {ClkStatusText, 0, Button2, spawn, {.v = termcmd}}, // Needs spawn prototype
    {ClkClientWin,
     MODKEY,
     Button1,
     movemouse,
     {0}}, // Needs movemouse prototype
    {ClkClientWin,
     MODKEY,
     Button2,
     togglefloating,
     {0}}, // Needs togglefloating prototype
    {ClkClientWin,
     MODKEY,
     Button3,
     resizemouse,
     {0}},                                        // Needs resizemouse prototype
    {ClkTagBar, 0, Button1, view, {0}},           // Needs view prototype
    {ClkTagBar, 0, Button3, toggleview, {0}},     // Needs toggleview prototype
    {ClkTagBar, MODKEY, Button1, tag, {0}},       // Needs tag prototype
    {ClkTagBar, MODKEY, Button3, toggletag, {0}}, // Needs toggletag prototype
};
