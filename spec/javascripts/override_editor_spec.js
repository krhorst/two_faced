describe("Override Editor", function () {

    beforeEach(function () {
        loadFixtures("active_admin_edit.html");
    });

    describe("initial page state", function () {

        it("should have the first tab active", function () {
            var default_tab = $(".editor-tabs [data-editor-id='-1']");
            expect(default_tab).toHaveClass("active");
        });

        it("should have only one active tab", function () {
            var active_tabs = $(".editor-tabs .active");
            expect(active_tabs.length).toBe(1);
        });

        it("should have the first tab editor visible", function () {
            var default_editor = $(".editors [data-editor-id='-1']");
            expect(default_editor).toHaveClass("active");
        });

        it("should have only one active editor", function () {
            var active_editors = $(".editors .active");
            expect(active_editors.length).toBe(1);
        });

        it("should have text in the second tab", function () {
            var second_tab_text = $(".editor-tabs [data-editor-id='1']").text();
            expect(second_tab_text).toBe("facebook");
        });

        it("should have text in the original tab", function () {
            var first_tab_text = $(".editor-tabs [data-editor-id='-1']").text();
            expect(first_tab_text).toBe("Default");
        });

    });

    describe("on click of second tab", function () {

        beforeEach(function () {
            var second_tab = $(".editor-tabs [data-editor-id='1']");
            second_tab.click();

        });

        it("should activate the second tab", function () {
            var second_tab = $(".editor-tabs [data-editor-id='1']");
            expect(second_tab).toHaveClass("active");
        });

        it("should focus on the input in the second tab", function () {
            var tab_input_is_focused = $(".editor-tabs [data-editor-id='1'] input").is(":focus");
            expect(tab_input_is_focused).toBeTruthy();
        });

        it("should have only one active tab", function () {
            var active_tabs = $(".editor-tabs .active");
            expect(active_tabs.length).toBe(1);
        });


        it("should have the second tab editor visible", function () {
            var default_editor = $(".editors [data-editor-id='1']");
            expect(default_editor).toHaveClass("active");
        });

        it("should have only one active editor", function () {
            var active_editors = $(".editors .active");
            expect(active_editors.length).toBe(1);
        });

        it("should have text in the original tab", function () {
            var first_tab_text = $(".editor-tabs [data-editor-id='-1']").text();
            expect(first_tab_text).toBe("Default");
        });

        it("should have a text input with the value of the label in the second tab", function () {
            var tab_input_value = $(".editor-tabs [data-editor-id='1'] input").val();
            expect(tab_input_value).toBe("facebook");
        });


    });

    describe("on click of second tab and back to first", function () {

        beforeEach(function () {
            var first_tab = $(".editor-tabs [data-editor-id='-1']");
            var second_tab = $(".editor-tabs [data-editor-id='1']");
            second_tab.click();
            first_tab.click();
        });

        it("should have text in the second tab", function () {
            var second_tab_text = $(".editor-tabs [data-editor-id='1']").text();
            expect(second_tab_text).toBe("facebook");
        });

        it("should have text in the original tab", function () {
            var first_tab_text = $(".editor-tabs [data-editor-id='-1']").text();
            expect(first_tab_text).toBe("Default");
        });

    });


    describe("on click of second tab, emptying context and back to first", function () {

        beforeEach(function () {
            var first_tab = $(".editor-tabs [data-editor-id='-1']");
            var second_tab = $(".editor-tabs [data-editor-id='1']");
            second_tab.click();
            second_tab.find("input").val("");
            first_tab.click();
        });

        it("the second tab should be called *blank*", function () {
            var second_tab_text = $(".editor-tabs [data-editor-id='1']").text();
            expect(second_tab_text).toBe("*blank*");
        });


    });


    describe("on click of add button", function () {
        beforeEach(function () {
            var new_tab_button = $(".editor-tabs .button");
            new_tab_button.click();
        });


        it("should activate the new tab", function () {
            var last_tab = $(".editor-tabs > li").last();
            expect(last_tab).toHaveClass("active");
        });

        it("should have only one active tab", function () {
            var active_tabs = $(".editor-tabs .active");
            expect(active_tabs.length).toBe(1);
        });


        it("should have the second tab editor visible", function () {
            var last_editor = $(".editors > li").last();
            expect(last_editor).toHaveClass("active");
        });

        it("should have only one active editor", function () {
            var active_editors = $(".editors .active");
            expect(active_editors.length).toBe(1);
        });


        describe("after clicking to the second tab", function () {

            beforeEach(function () {
                var second_tab = $(".editor-tabs [data-editor-id='1']");
                second_tab.click();
            });

            it("should have a tab called *new*", function () {
                var last_tab_text = $(".editor-tabs > li").last().text();
                expect(last_tab_text).toBe("*new*");
            });

        });

    });


});