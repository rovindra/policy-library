#
# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package templates.gcp.GKEDashboardConstraintV1

import data.validator.gcp.lib as lib

deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	asset := input.asset
	asset.asset_type == "container.googleapis.com/Cluster"

	container := asset.resource.data
	disabled := dashboard_disabled(container)
	disabled == false

	message := sprintf("%v has kubernetes dashboard enabled.", [asset.name])
	metadata := {"resource": asset.name}
}

###########################
# Rule Utilities
###########################
dashboard_disabled(container) = dashboard_disabled {
	addons_config := lib.get_default(container, "addonsConfig", "default")
	dashboard := lib.get_default(addons_config, "kubernetesDashboard", "default")
	dashboard_disabled := lib.get_default(dashboard, "disabled", false)
}