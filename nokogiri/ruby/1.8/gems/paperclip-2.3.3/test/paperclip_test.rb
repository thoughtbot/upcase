require 'test/helper'

class PaperclipTest < Test::Unit::TestCase
  [:image_magick_path, :command_path].each do |path|
    context "Calling Paperclip.run with #{path} specified" do
      setup do
        Paperclip.options[:image_magick_path] = nil
        Paperclip.options[:command_path]      = nil
        Paperclip.options[path]               = "/usr/bin"
      end

      should "return the expected path for path_for_command" do
        assert_equal "/usr/bin/convert", Paperclip.path_for_command("convert")
      end

      should "execute the right command" do
        Paperclip.expects(:path_for_command).with("convert").returns("/usr/bin/convert")
        Paperclip.expects(:bit_bucket).returns("/dev/null")
        Paperclip.expects(:"`").with("/usr/bin/convert 'one.jpg' 'two.jpg' 2>/dev/null")
        Paperclip.run("convert", "one.jpg", "two.jpg")
      end
    end
  end

  context "Calling Paperclip.run with no path specified" do
    setup do
      Paperclip.options[:image_magick_path] = nil
      Paperclip.options[:command_path]      = nil
    end

    should "return the expected path fro path_for_command" do
      assert_equal "convert", Paperclip.path_for_command("convert")
    end

    should "execute the right command" do
      Paperclip.expects(:path_for_command).with("convert").returns("convert")
      Paperclip.expects(:bit_bucket).returns("/dev/null")
      Paperclip.expects(:"`").with("convert 'one.jpg' 'two.jpg' 2>/dev/null")
      Paperclip.run("convert", "one.jpg", "two.jpg")
    end
  end

  context "Calling Paperclip.run and logging" do
    should "log the command when :log_command is true" do
      Paperclip.options[:image_magick_path] = nil
      Paperclip.options[:command_path]      = nil
      Paperclip.stubs(:bit_bucket).returns("/dev/null")
      Paperclip.expects(:log).with("this 'is the command' 2>/dev/null")
      Paperclip.expects(:"`").with("this 'is the command' 2>/dev/null")
      Paperclip.options[:log_command] = true
      Paperclip.run("this","is the command")
    end

    should "not log the command when :log_command is false" do
      Paperclip.options[:image_magick_path] = nil
      Paperclip.options[:command_path]      = nil
      Paperclip.stubs(:bit_bucket).returns("/dev/null")
      Paperclip.expects(:log).with("this 'is the command' 2>/dev/null").never
      Paperclip.expects(:"`").with("this 'is the command' 2>/dev/null")
      Paperclip.options[:log_command] = false
      Paperclip.run("this","is the command")
    end
  end

  context "Calling Paperclip.run when the command is not found" do
    should "tell you the command isn't there if the shell returns 127" do
      begin
        assert_raises(Paperclip::CommandNotFoundError) do
          `ruby -e 'exit 127'` # Stub $?.exitstatus to be 127, i.e. Command Not Found.
          Paperclip.stubs(:"`").returns("")
          Paperclip.run("command")
        end
      ensure
        `ruby -e 'exit 0'` # Unstub $?.exitstatus
      end
    end
    should "tell you the command isn't there if an ENOENT is raised" do
      assert_raises(Paperclip::CommandNotFoundError) do
        Paperclip.stubs(:"`").raises(Errno::ENOENT)
        Paperclip.run("command")
      end
    end
  end

  should "prevent dangerous characters in the command via quoting" do
    Paperclip.options[:image_magick_path] = nil
    Paperclip.options[:command_path]      = nil
    Paperclip.options[:log_command]       = false
    Paperclip.options[:swallow_stderr]    = false
    Paperclip.expects(:"`").with(%q[this 'is' 'jack'\''s' '`command`' 'line!'])
    Paperclip.run("this", "is", "jack's", "`command`", "line!")
  end

  context "Paperclip.bit_bucket" do
    context "on systems without /dev/null" do
      setup do
        File.expects(:exists?).with("/dev/null").returns(false)
      end

      should "return 'NUL'" do
        assert_equal "NUL", Paperclip.bit_bucket
      end
    end

    context "on systems with /dev/null" do
      setup do
        File.expects(:exists?).with("/dev/null").returns(true)
      end

      should "return '/dev/null'" do
        assert_equal "/dev/null", Paperclip.bit_bucket
      end
    end
  end

  should "raise when sent #processor and the name of a class that exists but isn't a subclass of Processor" do
    assert_raises(Paperclip::PaperclipError){ Paperclip.processor(:attachment) }
  end

  should "raise when sent #processor and the name of a class that doesn't exist" do
    assert_raises(NameError){ Paperclip.processor(:boogey_man) }
  end

  should "return a class when sent #processor and the name of a class under Paperclip" do
    assert_equal ::Paperclip::Thumbnail, Paperclip.processor(:thumbnail)
  end

  context "An ActiveRecord model with an 'avatar' attachment" do
    setup do
      rebuild_model :path => "tmp/:class/omg/:style.:extension"
      @file = File.new(File.join(FIXTURES_DIR, "5k.png"), 'rb')
    end

    teardown { @file.close }

    should "not error when trying to also create a 'blah' attachment" do
      assert_nothing_raised do
        Dummy.class_eval do
          has_attached_file :blah
        end
      end
    end

    context "that is attr_protected" do
      setup do
        Dummy.class_eval do
          attr_protected :avatar
        end
        @dummy = Dummy.new
      end

      should "not assign the avatar on mass-set" do
        @dummy.attributes = { :other => "I'm set!",
                              :avatar => @file }

        assert_equal "I'm set!", @dummy.other
        assert ! @dummy.avatar?
      end

      should "still allow assigment on normal set" do
        @dummy.other  = "I'm set!"
        @dummy.avatar = @file

        assert_equal "I'm set!", @dummy.other
        assert @dummy.avatar?
      end
    end

    context "with a subclass" do
      setup do
        class ::SubDummy < Dummy; end
      end

      should "be able to use the attachment from the subclass" do
        assert_nothing_raised do
          @subdummy = SubDummy.create(:avatar => @file)
        end
      end

      should "be able to see the attachment definition from the subclass's class" do
        assert_equal "tmp/:class/omg/:style.:extension",
                     SubDummy.attachment_definitions[:avatar][:path]
      end

      teardown do
        Object.send(:remove_const, "SubDummy") rescue nil
      end
    end

    should "have an #avatar method" do
      assert Dummy.new.respond_to?(:avatar)
    end

    should "have an #avatar= method" do
      assert Dummy.new.respond_to?(:avatar=)
    end

    context "that is valid" do
      setup do
        @dummy = Dummy.new
        @dummy.avatar = @file
      end

      should "be valid" do
        assert @dummy.valid?
      end
    end

    context "a validation with an if guard clause" do
      setup do
        Dummy.send(:"validates_attachment_presence", :avatar, :if => lambda{|i| i.foo })
        @dummy = Dummy.new
        @dummy.stubs(:avatar_file_name).returns(nil)
      end

      should "attempt validation if the guard returns true" do
        @dummy.expects(:foo).returns(true)
        assert ! @dummy.valid?
      end

      should "not attempt validation if the guard returns false" do
        @dummy.expects(:foo).returns(false)
        assert @dummy.valid?
      end
    end

    context "a validation with an unless guard clause" do
      setup do
        Dummy.send(:"validates_attachment_presence", :avatar, :unless => lambda{|i| i.foo })
        @dummy = Dummy.new
        @dummy.stubs(:avatar_file_name).returns(nil)
      end

      should "attempt validation if the guard returns true" do
        @dummy.expects(:foo).returns(false)
        assert ! @dummy.valid?
      end

      should "not attempt validation if the guard returns false" do
        @dummy.expects(:foo).returns(true)
        assert @dummy.valid?
      end
    end

    def self.should_validate validation, options, valid_file, invalid_file
      context "with #{validation} validation and #{options.inspect} options" do
        setup do
          Dummy.send(:"validates_attachment_#{validation}", :avatar, options)
          @dummy = Dummy.new
        end
        context "and assigning nil" do
          setup do
            @dummy.avatar = nil
            @dummy.valid?
          end
          if validation == :presence
            should "have an error on the attachment" do
              assert @dummy.errors[:avatar_file_name]
            end
          else
            should "not have an error on the attachment" do
              assert @dummy.errors[:avatar_file_name].blank?, @dummy.errors.full_messages.join(", ")
            end
          end
        end
        context "and assigned a valid file" do
          setup do
            @dummy.avatar = valid_file
            @dummy.valid?
          end
          should "not have an error when assigned a valid file" do
            assert_equal 0, @dummy.errors.length, @dummy.errors.full_messages.join(", ")
          end
        end
        context "and assigned an invalid file" do
          setup do
            @dummy.avatar = invalid_file
            @dummy.valid?
          end
          should "have an error when assigned a valid file" do
            assert @dummy.errors.length > 0
          end
        end
      end
    end

    [[:presence,      {},                              "5k.png",   nil],
     [:size,          {:in => 1..10240},               "5k.png",   "12k.png"],
     [:size,          {:less_than => 10240},           "5k.png",   "12k.png"],
     [:size,          {:greater_than => 8096},         "12k.png",  "5k.png"],
     [:content_type,  {:content_type => "image/png"},  "5k.png",   "text.txt"],
     [:content_type,  {:content_type => "text/plain"}, "text.txt", "5k.png"],
     [:content_type,  {:content_type => %r{image/.*}}, "5k.png",   "text.txt"]].each do |args|
      validation, options, valid_file, invalid_file = args
      valid_file   &&= File.open(File.join(FIXTURES_DIR, valid_file), "rb")
      invalid_file &&= File.open(File.join(FIXTURES_DIR, invalid_file), "rb")

      should_validate validation, options, valid_file, invalid_file
    end

    context "with size validation and less_than 10240 option" do
      context "and assigned an invalid file" do
        setup do
          Dummy.send(:"validates_attachment_size", :avatar, :less_than => 10240)
          @dummy = Dummy.new
          @dummy.avatar &&= File.open(File.join(FIXTURES_DIR, "12k.png"), "rb")
          @dummy.valid?
        end

        should "have a file size min/max error message" do
          assert [@dummy.errors[:avatar_file_size]].flatten.any?{|error| error =~ %r/between 0 and 10240 bytes/ }
        end
      end
    end

  end
end
