import sys
import argparse
import os
from PIL import Image

LOGO_PATH = "logo_game.png"
OUTPUT_PATH = "background.png"
BACKGROUND_DIR = "backgrounds"
TARGET_SIZE = (1920, 1080)

def crop_center(image: Image.Image, target_size: tuple):
    width, height = image.size
    target_width, target_height = target_size

    left = max((width - target_width) // 2, 0)
    top = max((height - target_height) // 2, 0)
    right = min(left + target_width, width)
    bottom = min(top + target_height, height)

    return image.crop((left, top, right, bottom))

def add_logo_to_background(background_path: str):
    try:
        background = Image.open(background_path)
        logo = Image.open(LOGO_PATH)

        if logo.mode != 'RGBA':
            logo = logo.convert('RGBA')

        if background.mode != 'RGBA':
            background = background.convert('RGBA')

        background = crop_center(background, TARGET_SIZE)
        background.paste(logo, (0, 0), logo)
        background.save(OUTPUT_PATH)
        print(f"Background generated successfully")
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Add a logo to a background image.")
    parser.add_argument("background_image", help="Path to the background image.")
    args = parser.parse_args()

    add_logo_to_background(os.path.join(BACKGROUND_DIR, args.background_image))
