require 'spec_helper'
require 'angular/html2js/template'

module Angular
  module Html2js
    describe Template do

      it 'should convert html to js code' do
        result = process '<h1>hello</h1>', 'tpl.html'
        result.should define_module('tpl.html').
          with_template_id('tpl.html').
          and_content('<h1>hello</h1>')
      end

      it 'should preserve new lines' do
        result = process "first\nsecond", 'path/tpl.html'
        result.should define_module('path/tpl.html').
          with_template_id('path/tpl.html').
          and_content("first\nsecond")
      end

      it 'should ignore Windows new lines' do
        result = process "first\r\nsecond", 'path/tpl.html'
        result.should_not include("\r")
      end

      it 'should preserve the backslash character' do
        result = process "first\\second", 'path/tpl.html'
        result.should define_module('path/tpl.html').
          with_template_id('path/tpl.html').
          and_content("first\\second")
      end

      describe 'configuration' do
        describe 'cache_id_from_path ' do
          before do
            Html2js.configure do |config|
              config.cache_id_from_path { |file_path| "generated_id_for/#{file_path}" }
            end
          end


          it 'invokes custom transform block' do
            result = process '<html></html>', 'path/tpl.html'
            result.should define_module('generated_id_for/path/tpl.html').
              with_template_id('generated_id_for/path/tpl.html').
              and_content('<html></html>')
          end
        end
      end

      def process(template_str, file_name, locals={})
        template = Template.new { template_str }
        template.file = file_name
        template.render(self, locals)
      end

    end
  end
end
