# Load path.yml file to set the right paths 
# for scanning and linking to Archive files
PATHS = YAML.load_file("#{Rails.root}/config/paths.yml")[Rails.env]
