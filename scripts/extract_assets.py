import os
from PIL import Image

assets_dir = r"D:\arc\assets\images"

def get_crops():
    # Screen 2: Welcome hero
    s2_path = os.path.join(assets_dir, "ARC-screen2.png")
    if os.path.exists(s2_path):
        s2 = Image.open(s2_path)
        w, h = s2.size
        # Welcome illustration is roughly in the top 15% to 45%
        # crop hero area
        crop_box = (int(w * 0.08), int(h * 0.12), int(w * 0.92), int(h * 0.40))
        hero_welcome = s2.crop(crop_box)
        hero_welcome.save(os.path.join(assets_dir, "hero_welcome.png"))
        print("Extracted hero_welcome.png")

    # Screen 6 or 7: Build Strength hero
    s7_path = os.path.join(assets_dir, "ARC-screen7.png")
    if os.path.exists(s7_path):
        s7 = Image.open(s7_path)
        w, h = s7.size
        # The hero card image inside Screen 7 is roughly around y: 0.17 to 0.41, x: 0.11 to 0.89
        crop_box = (int(w * 0.115), int(h * 0.175), int(w * 0.885), int(h * 0.42))
        hero_strength = s7.crop(crop_box)
        hero_strength.save(os.path.join(assets_dir, "hero_strength.png"))
        print("Extracted hero_strength.png")

    # Screen 9: Avatar & Mountain focus banner
    s9_path = os.path.join(assets_dir, "ARC-screen9.png")
    if os.path.exists(s9_path):
        s9 = Image.open(s9_path)
        w, h = s9.size
        # Avatar is top right near y: 0.065 to 0.10, x: 0.80 to 0.88
        avatar_box = (int(w * 0.80), int(h * 0.065), int(w * 0.88), int(h * 0.107))
        avatar = s9.crop(avatar_box)
        avatar.save(os.path.join(assets_dir, "avatar.png"))
        print("Extracted avatar.png")

    # Screen 10: The 4 Cards in 2-column grid
    s10_path = os.path.join(assets_dir, "ARC-screen10.png")
    if os.path.exists(s10_path):
        s10 = Image.open(s10_path)
        w, h = s10.size
        # Two columns:
        # Col 1: left ~0.11 to 0.49
        # Col 2: right ~0.51 to 0.89
        # Row 1: top ~0.23 to 0.55
        # Row 2: top ~0.57 to 0.85
        card1_box = (int(w * 0.11), int(h * 0.23), int(w * 0.49), int(h * 0.555))
        card2_box = (int(w * 0.51), int(h * 0.23), int(w * 0.89), int(h * 0.555))
        card3_box = (int(w * 0.11), int(h * 0.57), int(w * 0.49), int(h * 0.855))
        card4_box = (int(w * 0.51), int(h * 0.57), int(w * 0.89), int(h * 0.855))

        c1 = s10.crop(card1_box)
        c1.save(os.path.join(assets_dir, "card_strength.png"))
        
        c2 = s10.crop(card2_box)
        c2.save(os.path.join(assets_dir, "card_reset.png"))
        
        c3 = s10.crop(card3_box)
        c3.save(os.path.join(assets_dir, "card_cpp.png"))
        
        c4 = s10.crop(card4_box)
        c4.save(os.path.join(assets_dir, "card_summer.png"))
        print("Extracted Screen 10 cards")

if __name__ == "__main__":
    get_crops()
