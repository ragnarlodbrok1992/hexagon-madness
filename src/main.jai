// Basic top level imports
#import "Basic";
#import "GL";
#import "Window_Creation";
#import "Input";

// Named imports
Simp :: #import "Simp";
GetRect :: #import "GetRect";

// Local imports
#load "shaders.jai";
#load "camera.jai";
#load "text.jai";

// Consts
WINDOW_TITLE_BAR : string = "Hexagon Madness - developer version";
WINDOW_WIDTH := 1024;
WINDOW_HEIGHT := 768;

// Engine variables
ENGINE_SHOULD_QUIT := false;
MAIN_ENGINE_WINDOW : *void;

// Camera variables
MAIN_CAMERA : Camera;
CAMERA_CONTROL : bool = true;

// Fonts - variables
BIG_FONT    : *Simp.Dynamic_Font;
MEDIUM_FONT : *Simp.Dynamic_Font;
SMALL_FONT  : *Simp.Dynamic_Font;

// Fonts - datafiles
FONT_PATH             := "assets/fonts";
BIG_FONT_FILE_NAME    := "Quicksand-Bold.ttf";
MEDIUM_FONT_FILE_NAME := "Quicksand-Regular.ttf";
SMALL_FONT_FILE_NAME  := "Quicksand-Light.ttf";

init_fonts :: () {
  // Dividing by number of "columns" which is a good definitions of
  // requested font size.
  BIG_FONT_PIXEL_SIZE    := WINDOW_HEIGHT / 36;
  MEDIUM_FONT_PIXEL_SIZE := WINDOW_HEIGHT / 40;
  SMALL_FONT_PIXEL_SIZE  := WINDOW_HEIGHT / 46;
  
  // Setting fonts
  BIG_FONT    = Simp.get_font_at_size(FONT_PATH, BIG_FONT_FILE_NAME, BIG_FONT_PIXEL_SIZE);
  assert(BIG_FONT != null);
  MEDIUM_FONT = Simp.get_font_at_size(FONT_PATH, MEDIUM_FONT_FILE_NAME, MEDIUM_FONT_PIXEL_SIZE);
  assert(MEDIUM_FONT != null);
  SMALL_FONT  = Simp.get_font_at_size(FONT_PATH, SMALL_FONT_FILE_NAME, SMALL_FONT_PIXEL_SIZE);
  assert(SMALL_FONT != null);
}

handle_events :: (event: Event) {
  GetRect.getrect_handle_event(event);

  if event.type == {
    case .QUIT;
      ENGINE_SHOULD_QUIT = true;
    case .KEYBOARD;
      if event.key_pressed {
        if event.key_code == .ESCAPE {
          ENGINE_SHOULD_QUIT = true;
        }
      }
  }
}

update_and_render_ui :: () {
  // Drawing some text
  // @TIP: bottom left is (0, 0), top left is (0, y), bottom right is (x, 0)
  // draw_text(MEDIUM_FONT, .{1, 0, 0, 1}, "Welcome to Sea of Profit!", 100, 200);
  draw_text("Welcome to Hexagon Madness!", 0, 0);

}

main :: () {
  // Start message
  print("Sea of Profit\n");

  // Defer gracefull ending - if message is not printed, bad stuff happened!
  defer print("Engine exited successfully!\n");

  // Set Windows DPI aware stuff
  #if OS == .WINDOWS {
    win32 :: #import "Windows";
    win32.SetProcessDPIAware();
  }

  // Initializing Simp
  MAIN_ENGINE_WINDOW = create_window(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_TITLE_BAR);
  Simp.set_render_target(MAIN_ENGINE_WINDOW);

  // Initializing GetRect
  GetRect.ui_init();
  init_fonts();

  // Setting render dimensions
  simp_window_width, simp_window_height := Simp.get_render_dimensions(MAIN_ENGINE_WINDOW);
  
  // DEBUG
  print("Simp window width:  %\n", simp_window_width);
  print("Simp window height: %\n", simp_window_height);

  // Setup simp stuff for getting rect?
  Simp.set_render_target(MAIN_ENGINE_WINDOW);

  // Loading shaders
  shaders_program_id := load_shaders();
  // @TODO: get line shader from skeletal animation

  while !ENGINE_SHOULD_QUIT {

    update_window_events();

    for events_this_frame {
      handle_events(it);
    }

  // Clearing screen
  Simp.clear_render_target(.15, .08, .08, 1);
  Simp.set_shader_for_color();

  // Updating UI
  update_and_render_ui();

  // Swapping buffers
  Simp.swap_buffers(MAIN_ENGINE_WINDOW);
  }
  // End of main
}

