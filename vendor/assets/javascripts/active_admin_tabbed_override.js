(function () {

    var override_control = {
        initialize: function () {
            this.bindChangeOverrideTabsOnTabClick();
            this.bindCreateNewTabFormOnAddClick();
        },

        bindChangeOverrideTabsOnTabClick: function () {
            var _this = this;
            $(document).on("click", ".active_admin .editor-tabs li", function () {
                _this.changeOverrideTab(this);
            });
        },

        changeOverrideTab: function (tab_link) {
            var $context = this.getContext(tab_link);
            this.activateCurrentTab(tab_link);
            this.deactivateOtherTabs(tab_link, $context);
            this.makeOldTabUneditable(tab_link, $context);
            this.makeNewTabHeaderEditable(tab_link, $context);
            this.deactivateOtherTabContent(tab_link, $context);
            this.activateCurrentTabContent(tab_link, $context);
        },

        getContext: function (item) {
            return $(item).closest(".overridetextarea, .overridestring");
        },

        makeOldTabUneditable: function (tab_link, $context) {
            var _this = this;
            var $all_header_inputs_except_new = $context.find(".editor-tabs > li").not(tab_link);
            $all_header_inputs_except_new.each(function () {
                _this.moveInputFromHeaderToEditor($(this), $context);
            });
        },

        moveInputFromHeaderToEditor: function ($tab, $context) {
            var $input = $tab.find(".header-input");
            if ($input.length) {
                var editorId = this.getTabIdFromTab($tab);
                var current_value = $input.val();
                $context.find('.editors > li[data-editor-id=' + editorId + ']').append($input);
                if (current_value == ""){
                    if ($tab.hasClass("new")){
                    $tab.html("*new*");
                    } else {
                        $tab.html("*blank*");
                    }
                } else {
                    $tab.html(current_value);
                }
            }
        },

        isNotCurrentTab: function (tab, $context) {
            var $current_active = this.getCurrentActiveTab($context);
            return $current_active != tab;
        },

        getCurrentActiveTab: function ($context) {
            return $context.find('.editor-tabs .active');
        },

        makeNewTabHeaderEditable: function (tab_link, $context) {
            if (this.isNotCurrentTab(tab_link, $context)) {
                var editorId = this.getTabIdFromTab(tab_link);
                var $input = $context.find('.editors > li[data-editor-id=' + editorId + '] .header-input');
                if ($input.length){
                    this.getCurrentActiveTab($context).empty().append($input);
                    $input.focus();
                }
            }
        },

        activateCurrentTab: function (tab) {
            $(tab).addClass('active');
        },

        deactivateOtherTabs: function (tab, $context) {
            $context.find('.editor-tabs > li').not(tab).removeClass('active');
        },

        activateCurrentTabContent: function (tab, $context) {
            var editorId = this.getTabIdFromTab(tab);
            return $context.find('.editors > li[data-editor-id=' + editorId + ']').addClass("active");
        },

        getTabIdFromTab: function (tab) {
            return $(tab).attr("data-editor-id");
        },

        deactivateOtherTabContent: function (tab, $context) {
            var editorId = this.getTabIdFromTab(tab);
            $context.find('.editors > li').not('[data-editor-id=' + editorId + ']').removeClass("active");
        },

        bindCreateNewTabFormOnAddClick: function () {
            var _this = this;
            $(document).on("click", ".editor-tabs .button", function () {
                _this.addNewTabForm(this);
            });
        },

        addNewTabForm: function (form_button) {
            var $context = this.getContext(form_button);
            var unique_id = this.getUniqueIdFromTime();
            var template = this.getTemplateFromButton(form_button);
            var form = this.generateNewFormForTemplateAndId(template, unique_id);
            this.addNewTabContent(form, $context);
            var new_link = this.createNewTabLink(unique_id, $context);
            this.changeOverrideTab(new_link);
        },

        getTemplateFromButton: function (button) {
            return $(button).attr("data-template");
        },

        getUniqueIdFromTime: function () {
            return new Date().getTime();
        },

        generateNewFormForTemplateAndId: function (template, id) {
            return template.replace(/NEW_RECORD/g, id).replace(/\\n/g, "").replace(/\\(.)/mg, "$1");
        },

        addNewTabContent: function (content, $context) {
            $context.find(".editors").append($(content));
        },

        createNewTabLink: function (id, $context) {
            $new_link = $("<li data-editor-id='" + id + "' class='new'>*new*</li>");
            $context.find('.editor-tabs').append($new_link);
            return $new_link;
        }

    };

    $(document).ready(function () {
        override_control.initialize();
    });


})();
