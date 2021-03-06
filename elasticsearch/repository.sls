{%- from "elasticsearch/map.jinja" import elasticsearch with context %}

include:
  - elasticsearch.service

{%- for repository, params in elasticsearch.get('repository', {}).items() %}

  {%- if params.get('type', False) == 'fs' %}
elasticsearch_repository_{{repository}}_dir:
  file.directory:
    - name: {{ params.settings.location }}
    - user: {{ elasticsearch.user }}
    - group: {{ elasticsearch.group }}
    - makedirs: True
    - dir_mode: 755
    - file_mode: 644
    - recurse:
      - user
      - group
      - mode
    - require_in:
      - module: elasticsearch_repository_{{repository}}
  {%- endif %}

elasticsearch_repository_{{repository}}:
  module.run:
    - elasticsearch.repository_create:
      - name: {{ repository }}
      - body: {{ params|json }}

{%- endfor %}