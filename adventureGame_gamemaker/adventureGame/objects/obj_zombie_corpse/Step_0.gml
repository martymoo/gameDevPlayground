if (image_index >= image_number - 1) 
    {
        // Stop the animation on the final frame
        image_speed = 0;
        image_index = image_number - 1; 
        
        // This is where you would place the instance_destroy() code
        // or transition to an idle sprite.
    }