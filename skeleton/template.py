import json
from jinja2 import Environment, Template

# Your Jinja template as a multiline string
template_str = """
# Specify the AWS region
region = "${{ values.region }}"
application_ci = "${{ values.ci }}"
vendor = "${{ values.vendor }}"
listeners = {
{% for listener in values.listeners %}
  {{ listener.port }}: {{ listener.backend_ips | dump }}{% if not loop.last %},{% endif %}
{% endfor %}
}
allowed_principles = [
{% for principle in values.allowed_principles %}
  {
    aws_account = {{ principle.vendor_account_id }}  
    role        = "{{ principle.vendor_role }}"      
  }{% if not loop.last %},{% endif %}
{% endfor %}
]
"""

# Sample input data mimicking Forge values
values = {
    "region": "us-west-2",
    "ci": "app-ci-123",
    "vendor": "VendorName",
    "listeners": [
        {"port": "443", "backend_ips": ["10.1.0.1", "10.1.0.2", "10.1.0.3"]},
        {"port": "1434", "backend_ips": ["10.2.0.0", "10.2.0.1"]},
        {"port": "5432", "backend_ips": ["10.3.0.0"]}
    ],
    "allowed_principles": [
        {"vendor_account_id": "123456789012", "vendor_role": "MyRole"},
        {"vendor_account_id": "987654321098", "vendor_role": "AnotherRole"}
    ]
}

# Create a Jinja2 environment and add a custom 'dump' filter using json.dumps
env = Environment()
env.filters['dump'] = lambda value: json.dumps(value)

# Compile the template
template = env.from_string(template_str)

# Render the template with the 'values' dictionary
output = template.render(values=values)

print(output)
