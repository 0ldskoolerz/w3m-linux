####################################################################################
# w3m — Windows 3.x style X11 window manager (github.com/0ldskoolerz/W3M)
####################################################################################

W3M_VERSION = v0.5.0
W3M_SITE = $(call github,0ldskoolerz,W3M,$(W3M_VERSION))
W3M_LICENSE = MIT
W3M_DEPENDENCIES = xlib_libX11 lua

define W3M_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define W3M_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/w3m $(TARGET_DIR)/usr/bin/w3m
	$(INSTALL) -d $(TARGET_DIR)/usr/share/w3m
	$(INSTALL) -d $(TARGET_DIR)/usr/share/w3m/plugins
	$(INSTALL) -m 0644 $(@D)/plugins/*.lua $(TARGET_DIR)/usr/share/w3m/plugins/
	$(INSTALL) -m 0644 $(@D)/config/w3m.conf $(TARGET_DIR)/usr/share/w3m/w3m.conf
endef

$(eval $(generic-package))
