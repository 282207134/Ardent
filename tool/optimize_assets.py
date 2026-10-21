"""Convert exported PNG assets to WebP, preserving alpha and source references."""
from pathlib import Path
from PIL import Image

root = Path(__file__).resolve().parents[1]
directory = (root / 'assets' / 'images').resolve()
assert directory.is_relative_to(root)
before = after = 0
for source in directory.glob('*.png'):
    destination = source.with_suffix('.webp')
    with Image.open(source) as image:
        image.save(destination, 'WEBP', quality=90, method=6)
    with Image.open(destination) as result:
        result.verify()
    before += source.stat().st_size
    after += destination.stat().st_size
    source.unlink()
for source in (root / 'lib').rglob('*.dart'):
    content = source.read_text(encoding='utf-8')
    content = content.replace('$name.png', '$name.webp').replace('images/avatar.png','images/avatar.webp')
    source.write_text(content, encoding='utf-8')
print(f'Asset bytes: {before:,} -> {after:,} ({(1-after/before)*100:.1f}% smaller)' if before else 'Assets already optimized')
