require 'rubygems'

gem 'hoe', '>= 2.5'
require 'hoe'

Hoe.plugin :debugging, :doofus, :git
Hoe.plugins.delete :rubyforge

Hoe.spec "envjs" do

  developer 'John Resig', 'jeresig@gmail.com'
  developer 'Chris Thatcher', 'thatcher.christopher@gmail.com'
  developer 'Steven Parkes', 'smparkes@smparkes.net'

  self.readme_file              = 'README.rdoc'
  self.extra_rdoc_files         = Dir['*.rdoc']
  self.history_file             = "CHANGELOG.rdoc"
  self.readme_file              = "README.rdoc"

  self.extra_deps = [
    ['johnson', '>= 2.0.0.pre3']
  ]

end

# task :test => :check_dependencies

namespace :gemspec do
  task :generate => "johnson:compile"
end

task :default => :test

namespace :rhino do
  desc "run tests aginst rhino"
  task :test do
    classpath = [
        File.join(".", "rhino", "ant.jar"), 
  	File.join(".", "rhino", "ant-launcher.jar")
    ].join(File::PATH_SEPARATOR)
    exec "java -cp #{classpath} org.apache.tools.ant.Main -emacs all"
  end
end

namespace :johnson do

  desc "create a file that loads the individual source files"
  task :load

  desc "compile johnson files into a single js file"
  task :compile do
    require 'rexml/document'
    include REXML
    doc = Document.new( File.new( "build.xml" ) ).root
    groups = {}
    XPath.each( doc, "//concat" ) do |concat|
      name = concat.attributes["destfile"]
      files =
        XPath.match( concat, "fileset/attribute::includes" ).
          map { |a| a.value }
      groups[name] = files
    end

    files = groups["${ENV_RHINO}"];
    files.map! { |f| f == "env.js" ? groups["${ENV_DIST}"] : f }.flatten!
    files.map! { |f| f.sub!( "rhino", "johnson" ); "src/" + f }

    static = [
               "src/platform/static/intro.js",
               "src/base64.js",
               "src/dom/nodelist.js",
               "src/dom/namednodemap.js",
               "src/dom/node.js",
               "src/dom/namespace.js",
               "src/dom/characterdata.js",
               "src/dom/text.js",
               "src/dom/cdatasection.js",
               "src/dom/comment.js",
               "src/dom/doctype.js",
               "src/dom/attr.js",
               "src/dom/element.js",
               "src/dom/exception.js",
               "src/dom/fragment.js",
               "src/dom/instruction.js",
               "src/dom/parser.js",
               "src/dom/entities.js",
               # "src/dom/implementation.js",
               "src/dom/document.js",
               "src/html/html.js",
               "src/html/document.js",
               "src/html/element.js",
               "src/html/collection.js",
               "src/html/input-elements.js",
               "src/html/a.js",
               "src/html/anchor.js",
               "src/html/area.js",
               "src/html/base.js",
               "src/html/blockquote-q.js",
               "src/html/body.js",
               "src/html/button.js",
               "src/html/col-colgroup.js",
               "src/html/del-ins.js",
               "src/html/div.js",
               "src/html/legend.js",
               "src/html/fieldset.js",
               "src/html/form.js",
               "src/html/frame.js",
               "src/html/frameset.js",
               "src/html/head.js",
               "src/html/iframe.js",
               "src/html/img.js",
               "src/html/input.js",
               "src/html/label.js",
               "src/html/link.js",
               "src/html/map.js",
               "src/html/meta.js",
               "src/html/object.js",
               "src/html/optgroup.js",
               "src/html/option.js",
               "src/html/param.js",
               "src/html/script.js",
               "src/html/select.js",
               "src/html/style.js",
               "src/html/table.js",
               "src/html/tbody-thead-tfoot.js",
               "src/html/td-th.js",
               "src/html/textarea.js",
               "src/html/title.js",
               "src/html/tr.js",
               "src/svg/document.js",
               "src/svg/element.js",
               "src/svg/animatedstring.js",
               "src/svg/stylable.js",
               "src/svg/rect.js",
               "src/svg/locatable.js",
               "src/svg/transformable.js",
               "src/svg/svgelement.js",
               "src/svg/rectelement.js",
               "src/parser/intro.js",
               "src/parser/html5.pretty.js",
               "src/parser/outro.js",
               "src/xpath/xmltoken.js",
               "src/xpath/expression.js",
               "src/xpath/result.js",
               "src/xpath/implementation.js",
               "src/xpath/util.js",
               "src/serializer/xml.js",
               "src/event/event.js",
               "src/event/mouseevent.js",
               "src/event/uievent.js",
               "src/css/properties.js",
               "src/css/rule.js",
               "src/css/stylesheet.js",
               "src/html/cookie.js",
               "src/platform/static/outro.js"
              ]
    _static = [
              "src/platform/static/intro.js",
              "src/dom/node.js",
              "src/platform/static/outro.js"
             ]
    
    files.reject! { |f| static.include? f }

    # puts files.join(" ")
    
    system "rm -f lib/envjs/env.js"
    system "cat #{files.join(' ')} > lib/envjs/env.js"
    system "chmod 444 lib/envjs/env.js"

    system "rm -f lib/envjs/static.js.tmp"
    system "cat /dev/null > lib/envjs/static.js.tmp"
    static.each do |f|
      system "cat #{f} >> lib/envjs/static.js.tmp; echo >> lib/envjs/static.js.tmp"
    end
    system "chmod 444 lib/envjs/static.js.tmp"
    system "mv -f lib/envjs/static.js.tmp lib/envjs/static.js"

  end

  desc "run tests against johnson"
  task :test => :compile do
    ruby "-Ilib bin/envjsrb test/primary-tests.js"
    ruby "-Ilib bin/envjsrb test/prototype-test.js"
    ruby "-Ilib bin/envjsrb test/call-load-test.js"
  end

end

desc "run tests on all platforms"
# task :test => "rhino:test"
task :test => "johnson:test"

# Local Variables:
# mode:ruby
# End:
