from jinja2 import Environment, FileSystemLoader
import os


TEMPLATE_DIR = os.path.join(os.path.dirname(__file__), '..', 'templates')


env = Environment(loader=FileSystemLoader(TEMPLATE_DIR))


def render_report(summary: dict, out_path: str):
tpl = env.get_template('report_template.html')
html = tpl.render(summary=summary)
with open(out_path, 'w', encoding='utf-8') as f:
f.write(html)
print('Report written to', out_path)