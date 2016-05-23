require "clamp"
require "ops_manager/product_deployment"
require "ops_manager/deployment"

class OpsManager
  class Cli < Clamp::Command

    class Target < Clamp::Command
      parameter "OPS_MANAGER_IP", "Ops Manager Ip", required: true

      def execute
        OpsManager.target(@ops_manager_ip)
      end
    end

    class Login < Clamp::Command
      parameter "USERNAME", "opsManager username", required: true
      parameter "PASSWORD", "opsManager password", required: true

      def execute
        OpsManager.login(@username, @password)
      end
    end

    class Deploy < Clamp::Command
      def execute
        OpsManager::Deployment.new.run
      end
    end

    class Deployment < Clamp::Command
      parameter "OPS_MANAGER_CONFIG", "opsManager config file", required: true

      def execute
        OpsManager.deployment=@ops_manager_config
      end
    end

    class DeployProduct < Clamp::Command
      parameter "PRODUCT_CONFIG", "opsManager product config file", required: true
      option "--force", :flag, "force deployment"

      def execute
        OpsManager::ProductDeployment.new(product_config, force?).run
      end
    end

    class GetInstallationSettings < Clamp::Command
      parameter "DESTINATION", "where should it place the donwloaded settings", required: true

      def execute
      OpsManager::Api::Opsman.new.get_installation_settings(write_to: @destination)
      end
    end

    class ImportStemcell < Clamp::Command
      parameter "STEMCELL_FILEPATH", "Stemcell filepath", required: true

      def execute
        OpsManager.new.import_stemcell(@stemcell_filepath)
      end
    end

    class DeleteUnusedProducts < Clamp::Command

      def execute
        OpsManager.new.delete_products
      end
    end

    subcommand "target", "target an ops_manager deployment" , Target
    subcommand "login", "login against ops_manager" , Login
    subcommand "deploy", "deploys or upgrades ops_manager" , Deploy
    subcommand "deployment", "sets deployment config file path" , Deployment
    subcommand "deploy-product", "deploys product tiles" , DeployProduct
    subcommand "get-installation-settings", "pulls installation settings" , GetInstallationSettings
    subcommand "import-stemcell", "Uploads stemcell to Ops Manager" , ImportStemcell
    subcommand "delete-unused-products", "Deletes unused products" , DeleteUnusedProducts
  end
end
