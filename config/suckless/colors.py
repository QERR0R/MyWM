import re
import os

input_file = os.path.expanduser('~/.cache/wal/colors-wal-dwm.h')
output_file = os.path.expanduser('~/.Xresources')

try:
    with open(input_file, 'r') as f:
        content = f.read()
except FileNotFoundError:
    print(f"Error: File not found - {input_file}")
    exit(1)

pattern = r'static const char (norm_fg|norm_bg|norm_border|sel_fg|sel_bg|sel_border)\[\] = "(#[0-9a-fA-F]+)";'

matches = re.findall(pattern, content)

colors = {}
for name, value in matches:
    colors[name] = value.lower()

output_content = f"""
dwm.normbordercolor: {colors.get('norm_border', '')}
dwm.normbgcolor: {colors.get('norm_bg', '')}
dwm.normfgcolor: {colors.get('norm_fg', '')}
dwm.selbordercolor: {colors.get('sel_border', '')}
dwm.selbgcolor: {colors.get('sel_bg', '')}
dwm.selfgcolor: {colors.get('sel_fg', '')}
"""

try:
    with open(output_file, 'w') as f:
        f.write("\n" + output_content)
    print(f"Successfully wrote DWM colors to {output_file}")
except IOError as e:
    print(f"Error writing to {output_file}: {e}")
