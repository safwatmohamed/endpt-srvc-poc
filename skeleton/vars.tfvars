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





