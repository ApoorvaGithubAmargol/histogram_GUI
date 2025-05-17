function trialGUI
    % Create figure
    fig = figure('Name','Adaptive Histogram GUI','Position',[100 100 800 500]);

    % Axes
    ax1 = axes('Parent',fig,'Position',[0.05 0.6 0.35 0.35]); % Original Image
    title(ax1, 'Original Image');

    ax2 = axes('Parent',fig,'Position',[0.55 0.6 0.35 0.35]); % Original Histogram
    title(ax2, 'Original Histogram');

    ax3 = axes('Parent',fig,'Position',[0.05 0.1 0.35 0.35]); % Enhanced Image
    title(ax3, 'Enhanced Image');

    ax4 = axes('Parent',fig,'Position',[0.55 0.1 0.35 0.35]); % Enhanced Histogram
    title(ax4, 'Enhanced Histogram');

    % Button--------------------------
    btn = uicontrol('Style','pushbutton','String','Input Image',...
        'Position',[20 450 100 30],'Callback',@loadImage);

    % Slider (only allow 8, 16, 32)
    sld = uicontrol('Style','slider','Min',1,'Max',3,'Value',2,...
        'SliderStep',[0.5 0.5],'Position',[150 455 200 20],...
        'Callback',@(src, event) sliderChanged);

    % Label
    lbl = uicontrol('Style','text','Position',[370 450 120 20],...
        'String','Window: 16x16');

    % Store handles and data
    data = struct( ...
        'fig', fig, ...
        'btn', btn, ...
        'ax1', ax1, ...
        'ax2', ax2, ...
        'ax3', ax3, ...
        'ax4', ax4, ...
        'slider', sld, ...
        'label', lbl, ...
        'img', [] ...
    );

    guidata(fig, data); % Store to GUI

    % --- CALLBACKS ---

    function loadImage(~,~)
        [file,path] = uigetfile({'*.jpg;*.png;*.bmp'},'Select an image');
        if isequal(file,0), return; end
        img = imread(fullfile(path,file));
        if size(img,3)==3
            img = rgb2gray(img);
        end

        % Optional: Resize for speed during testing
        % img = imresize(img, 0.5);

        data = guidata(fig);
        data.img = img;
        guidata(fig, data);

        imshow(img, 'Parent', data.ax1);

        % Show original histogram
        cla(data.ax2);
        histogram(double(img), 'Parent', data.ax2);

        % Update enhanced result too
        sliderChanged;
    end

    function sliderChanged()
        data = guidata(fig);
        if isempty(data.img), return; end

        val = round(get(data.slider, 'Value'));
        winSizes = [8, 16, 32];
        win = winSizes(val);
        set(data.label, 'String', sprintf('Window: %dx%d', win, win));

        [r, c] = size(data.img);
        numTiles = [max(1, floor(r / win)), max(1, floor(c / win))];

        enhanced = adapthisteq(data.img, 'NumTiles', numTiles, 'ClipLimit', 0.01);
        imshow(enhanced, 'Parent', data.ax3);

        cla(data.ax4);
        histogram(double(enhanced), 'Parent', data.ax4);
    end
end