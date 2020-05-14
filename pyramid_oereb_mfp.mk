OPERATING_SYSTEM ?=WINDOWS

INSTANCE_ID = oereb
DEVELOPMENT = TRUE

PRINT_OUTPUT ?= C:\Applications\ApacheTomcat9\webapps

# Print
PRINT_BASE_DIR ?= .
PRINT_WAR ?= print-$(INSTANCE_ID).war
PRINT_OUTPUT ?= C:\Applications\ApacheTomcat9\webapps
PRINT_OUTPUT_WAR =
PRINT_TMP ?= tmp
TOMCAT_START_COMMAND ?= net START Tomcat9
TOMCAT_STOP_COMMAND ?= net STOP Tomcat9
PRINT_OUTPUT_WAR = $(PRINT_OUTPUT)/$(PRINT_WAR)
PRINT_BASE_WAR ?= print-servlet.war
PRINT_INPUT += print-apps WEB-INF
PRINT_REQUIREMENT += \
	$(shell find $(PRINT_BASE_DIR)/print-apps)


# Print
.PHONY: print
print: $(PRINT_OUTPUT)/$(PRINT_WAR)

$(PRINT_OUTPUT)/$(PRINT_WAR): $(PRINT_REQUIREMENT)
# If Linux else windows
ifeq ($(OPERATING_SYSTEM), LINUX)
	cp $(PRINT_BASE_DIR)/$(PRINT_BASE_WAR) $(PRINT_TMP)/$(PRINT_WAR)
	cd $(PRINT_BASE_DIR) && jar -uf $(PRINT_TMP)/$(PRINT_WAR) $(PRINT_INPUT)
	chmod g+r,o+r $(PRINT_TMP)/$(PRINT_WAR)
else
	mkdir -p $(PRINT_BASE_DIR)/$(PRINT_TMP)
	cp $(PRINT_BASE_DIR)/$(PRINT_BASE_WAR) $(PRINT_BASE_DIR)/$(PRINT_TMP)/$(PRINT_WAR)
	cd $(PRINT_BASE_DIR) && jar -uf $(PRINT_TMP)/$(PRINT_WAR) $(PRINT_INPUT)
endif

ifneq ($(TOMCAT_STOP_COMMAND),)
	$(TOMCAT_STOP_COMMAND)
endif
	$(TOMCAT_OUTPUT_CMD_PREFIX) rm -f $(PRINT_OUTPUT)/$(PRINT_WAR)
	$(TOMCAT_OUTPUT_CMD_PREFIX) rm -rf $(PRINT_OUTPUT)/$(PRINT_WAR:.war=)
# If Linux else windows
ifeq ($(OPERATING_SYSTEM), LINUX)
	$(TOMCAT_OUTPUT_CMD_PREFIX) cp $(PRINT_TMP)/$(PRINT_WAR) $(PRINT_OUTPUT)
	rm -f $(PRINT_TMP)/$(PRINT_WAR)
else
	mv $(PRINT_BASE_DIR)/$(PRINT_TMP)/$(PRINT_WAR) $(PRINT_OUTPUT)
	cd $(PRINT_BASE_DIR) && rm -fd $(PRINT_TMP)
endif
ifneq ($(TOMCAT_START_COMMAND),)
	$(TOMCAT_START_COMMAND)
endif
