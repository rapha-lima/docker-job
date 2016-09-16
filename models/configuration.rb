class Configuration < Settingslogic
  source 'config/spot_instance_configuration.yml'
  namespace 'configuration'
  load!
end
