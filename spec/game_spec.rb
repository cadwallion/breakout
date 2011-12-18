require 'spec_helper'

describe Breakout::Game do
  def stubbed_container
    unless @container_stub
      @container_stub = double
      @container_stub.stub(:width) { 640 }
      @container_stub.stub(:height) { 480 }
      @container_stub.stub_chain(:get_input, :is_key_down => false)
    end
    @container_stub
  end

  def stubbed_image(x = 100, y = 25)
    unless @image_stub
      @image_stub = double
      @image_stub.stub(:width) { x }
      @image_stub.stub(:height) { 25 }
      @image_stub.stub(:draw) { true }
    end
    @image_stub 
  end

  def stub_game_object
    obj = double
    obj.stub(:draw) { true }
    obj
  end

  let(:container) { stubbed_container }

  describe '#init' do
    before do
      Image.stub(:new) { stubbed_image }
      subject.init(container)
    end
    it 'creates the background object' do
      subject.instance_variable_get(:@bg).should_not be_nil
    end

    it 'creates the ball object as an instance of Breakout::Ball' do
      ball = subject.instance_variable_get(:@ball)
      ball.should_not be_nil
      ball.should be_instance_of(Breakout::Ball)
    end

    it 'creates the paddle object as an instance of Breakout::Paddle' do
      paddle = subject.instance_variable_get(:@paddle)
      paddle.should_not be_nil
      paddle.should be_instance_of(Breakout::Paddle)
    end

    it 'creates the blocks array of 25 blocks' do
      blocks = subject.instance_variable_get(:@blocks)
      blocks.should be_instance_of(Array)
      blocks.size.should == 25
    end

    it 'fills the blocks array with 25 Breakout::Block objects' do
      blocks = subject.instance_variable_get(:@blocks)
      blocks.select { |b| b.class.name == 'Breakout::Block' }.size.should == 25
    end

    it 'sets the score to 0' do
      subject.instance_variable_get(:@score).should == 0
    end

    it 'sets the lives to 3' do
      subject.instance_variable_get(:@lives).should == 3
    end
  end

  describe '#update' do
    before do
      Image.stub(:new) { stubbed_image }
    end
    it 'calls #handle_input' do
      subject.should_receive(:handle_input)
      subject.stub(:game_won?) { true }
      subject.update(container, 4)
    end

    context 'game is not won or lost' do
      before do
        subject.stub(:game_won?) { false }
        subject.stub(:game_lost?) { false }
      end

      it 'calls Breakout::Ball#move' do
        Breakout::Game.any_instance.stub(:collision_detection)

        Breakout::Ball.any_instance.should_receive(:move)
        subject.init(container)
        subject.update(container, 4)
      end

      it 'calls collision_detection' do
        container.stub_chain(:get_input, :is_key_down => false)
        subject.should_receive(:collision_detection)

        subject.init(container)
        subject.update(container, 4)
      end
    end

    context 'game is won or lost' do
      before do
        subject.stub(:game_won?) { true }
        subject.stub(:game_lost?) { false }
      end

      it 'does not call Breakout::Ball#move' do
        subject.stub(:handle_input)
        Breakout::Ball.any_instance.should_not_receive(:move)
        subject.init(container)
        subject.update(container, 4)
      end

      it 'does not call collision_detection' do
        subject.stub(:handle_input)
        
        subject.should_not_receive(:collision_detection)
        subject.init(container)
        subject.update(container, 4)
      end
    end
  end

  describe '#render' do
    def stubbed_graphics
      d = double() 
      d.stub(:draw_string) { true }
      d
    end

    def stub_game_init
      subject.instance_variable_set(:@bg, stub_game_object)
      Breakout::Paddle.stub(:new) { stub_game_object }
      Breakout::Ball.stub(:new) { stub_game_object }
      Breakout::Block.stub(:new) { stub_game_object }
    end
    
    before do
      Image.stub(:new) { stubbed_image }
      stub_game_init
      subject.init(container)
    end

    let(:graphics) { stubbed_graphics }

    it 'draws the background' do
      subject.instance_variable_get(:@bg).should_receive(:draw)
      subject.render(container, graphics)
    end

    it 'draws the ball at its current coordinates' do
      subject.instance_variable_get(:@ball).should_receive(:draw)
      subject.render(container, graphics)
    end

    it 'draws the paddle as its current coordinates' do
      subject.instance_variable_get(:@paddle).should_receive(:draw)
      subject.render(container, graphics)
    end

    it 'draws all blocks to the screen' do
      blocks = subject.instance_variable_get(:@blocks)
      blocks.each do |block|
        block.should_receive(:draw)
      end
      subject.render(container, graphics)
    end

    it 'draws the score to the screen' do
      graphics.should_receive(:draw_string).with('SCORE: 0', container.width - 150, 10)
      subject.render(container, graphics)
    end

    it 'draws the lives left to the screen' do
      graphics.should_receive(:draw_string).with('LIVES: 3', container.width - 350, 10)
      subject.render(container, graphics)
    end

    it 'draws the escape message' do
      graphics.should_receive(:draw_string).with('RubyBreakout (ESC to exit)', 8, container.height - 30)
      subject.render(container, graphics)
    end

    context 'game is won' do
      before do
        subject.stub(:game_won?) { true }
      end

      it 'draws the win announcement to the screen' do
        graphics.should_receive(:draw_string).with('YOU WIN! :)', container.width / 2, container.height / 2)
        subject.render(container, graphics)
      end
    end

    context 'game is lost' do
      before do
        subject.stub(:game_lost?) { true }
      end

      it 'draws the loss announcement to the screen' do
        graphics.should_receive(:draw_string).with('YOU LOSE! :(', container.width / 2, container.height / 2)
        subject.render(container, graphics)
      end
    end
  end

  describe '#handle_input' do
    def input_stub(key_down = nil)
      input_stub = double
      input_stub.stub(:is_key_down) { false }
      if key_down 
        input_stub.stub(:is_key_down).with(key_down) { true }
      end
      input_stub
    end

    before do
      Image.stub(:new) { stubbed_image }
      subject.init(container)
    end

    it 'gets the input from the container' do
      container.should_receive(:get_input)
      subject.handle_input(container, 4)
    end
    
    it 'closes the program if [ESC] is pushed' do
      container.stub(:get_input) { input_stub(Input::KEY_ESCAPE) }
      container.stub(:exit) { true }
      container.should_receive(:exit) 
      subject.handle_input(container, 4)
    end
    
    describe "'A' key is pressed" do
      it_behaves_like 'a paddle movement key', 'left' do
        let(:key) { input_stub(Input::KEY_A) } 
      end
    end

    describe 'Left arrow key is pressed' do
      it_behaves_like 'a paddle movement key', 'left' do
        let(:key) { input_stub(Input::KEY_LEFT) }
      end
    end

    describe "'D' key is pressed" do
      it_behaves_like 'a paddle movement key', 'right' do
        let(:key) { input_stub(Input::KEY_D) }
      end
    end

    describe 'Right arrow key is pressed' do
      it_behaves_like 'a paddle movement key', 'right' do
        let(:key) { input_stub(Input::KEY_RIGHT) }
      end
    end
  end

  describe '#collision_detection' do
    before do
      Image.stub(:new) { stubbed_image }
      subject.init(container)
    end

    it 'bounces the ball if leaving the container' do
      ball = subject.instance_variable_get(:@ball)
      ball.stub(:leaving_the) { true }
      ball.should_receive(:bounce)
      subject.collision_detection(container, 4)
    end

    it 'bounces the ball if colliding with the paddle' do
      ball = subject.instance_variable_get(:@ball)
      paddle = subject.instance_variable_get(:@paddle)
      ball.stub(:is_colliding_with?) { false }
      ball.stub(:is_colliding_with?).with(paddle) { true }
      ball.should_receive(:bounce)
      subject.collision_detection(container, 4)
    end

    context 'if ball is colliding with a block' do
      before do
        @ball = subject.instance_variable_get(:@ball)
        @block = subject.instance_variable_get(:@blocks).first
        @ball.stub(:is_colliding_with?) { false }
        @ball.stub(:is_colliding_with?).with(@block) { true }
      end

      it 'bounces the ball' do
        @ball.should_receive(:bounce)
        subject.collision_detection(container, 4)
      end

      it 'increases the score by 150' do
        score = subject.instance_variable_get(:@score)   
        subject.collision_detection(container, 4)
        subject.instance_variable_get(:@score).should == score + 150
      end

      it 'deletes the block from the block array' do
        subject.collision_detection(container, 4)
        subject.instance_variable_get(:@blocks).should_not include(@block)
      end
    end

    it 'resets the state if ball hits the bottom' do
      subject.instance_variable_get(:@ball).stub(:leaving_the) { true }
      subject.should_receive(:reset)
      subject.collision_detection(container, 4)
    end
  end

  describe '#reset' do
    before do
      Image.stub(:new) { stubbed_image }
      subject.init(container)
    end

    it 'resets the paddle' do
      subject.instance_variable_get(:@paddle).should_receive(:reset)
      subject.reset
    end

    it 'resets the ball' do
      subject.instance_variable_get(:@ball).should_receive(:reset)
      subject.reset
    end

    it 'decreases the lives by 1' do
      lives = subject.instance_variable_get(:@lives)
      subject.reset
      subject.instance_variable_get(:@lives).should == lives - 1
    end
  end

  describe '#game_won?' do
    it 'returns true if all blocks are gone' do
      subject.instance_variable_set(:@blocks, [])
      subject.game_won?.should == true
    end

    it 'returns false if any blocks remain' do
      subject.instance_variable_set(:@blocks, [1])
      subject.game_won?.should == false
    end
  end

  describe '#game_lost?' do
    it 'returns true if all lives are gone' do
      subject.instance_variable_set(:@lives, 0)
      subject.game_lost?.should == true
    end

    it 'returns false if lives > 0' do
      subject.instance_variable_set(:@lives, 1)
      subject.game_lost?.should == false
    end
  end
end
