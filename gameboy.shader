shader_type canvas_item;

// Colors that we will use
uniform vec4 color_1 : hint_color = vec4(0.784313725, 0.788235294, 0.262745098, 1);
uniform vec4 color_2 : hint_color = vec4(0.490196078, 0.521568627, 0.152941176, 1);
uniform vec4 color_3 : hint_color = vec4(0, 0.415686275, 0, 1);
uniform vec4 color_4 : hint_color = vec4(0.015686275, 0.243137255, 0, 1);
 
// Color offset - changes threshold for color adjustments
uniform float offset = 0.5;

vec4 grayscale(vec4 color) {
	float average = (color.r + color.g + color.b) / 3.0;
	return vec4(average, average, average, 1);
}

vec4 colorize(vec4 color) {
	// Colorizes the grayscale pixel
    vec4 grayscale_ = color;
	vec4 new_color = grayscale_;
	
    if (grayscale_.r >= 0.0)
    {
        // Set darkest color 4
        new_color = color_4;
                 
        // Color greater than (default) 0.25 in value? 
        if(grayscale_.r > offset * 0.5)
        {
            // Set dark color 3
            new_color = color_3;
             
            // Color greater than (default) 0.50 in value? 
            if(grayscale_.r > offset)
            {
                // Set bright color 2
                new_color = color_2;
                 
                // Color greater than (default) 0.75 in value? 
                if(grayscale_.r > offset * 1.5)
                {
                    // Set brightest color 1
                    new_color = color_1;
                }
            }
        }
    }
	
	return new_color;
}

void fragment() {
	// Get pixel color from screen
	vec4 pixel_color = vec4(texture(TEXTURE, UV));

	// Run the color transformations.
	pixel_color = colorize(grayscale(pixel_color));
	 
	// Set the pixel color we are going to use
	COLOR = pixel_color;
}
