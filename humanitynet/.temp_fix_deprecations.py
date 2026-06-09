import re
from pathlib import Path
root = Path('lib')
re_opacity = re.compile(r"\.withOpacity\(([^)]+)\)")
changed = []
for path in root.rglob('*.dart'):
    text = path.read_text(encoding='utf-8')
    new = re_opacity.sub(lambda m: f'.withValues(alpha: ({m.group(1)} * 255).round())', text)
    new = new.replace('activeColor:', 'activeThumbColor:')
    if new != text:
        path.write_text(new, encoding='utf-8')
        changed.append(str(path))
print('changed', len(changed))
for p in changed:
    print(p)
