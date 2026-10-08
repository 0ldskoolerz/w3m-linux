####################################################################################
# w3m-apps — Win 3.x style applications for the W3M desktop
####################################################################################

W3M_APPS_VERSION = v0.1.0
W3M_APPS_SITE = $(call github,0ldskoolerz,w3m-apps,$(W3M_APPS_VERSION))
W3M_APPS_LICENSE = MIT
W3M_APPS_DEPENDENCIES = xlib_libX11 busybox

define W3M_APPS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define W3M_APPS_INSTALL_TARGET_CMDS
	for bin in w3m-fm w3m-term w3m-task w3m-calc w3m-notepad; do \
		$(INSTALL) -D -m 0755 $(@D)/$$bin $(TARGET_DIR)/usr/bin/$$bin; \
	done
endef

$(eval $(generic-package))
