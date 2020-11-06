% 簇心数目k
K = 4;

% 准备数据，假设是2维的,80条数据，从data.txt中读取
%data = zeros(100, 2);
load 'data.txt'; % 直接存储到data变量中

x = data(:,1);
y = data(:,2);

% 绘制数据，2维散点图
% x,y: 要绘制的数据点  20:散点大小相同，均为20  'blue':散点颜色为蓝色
s = scatter(x, y, 20, 'blue');
title('原始数据：蓝圈；初始簇心：红点');

% 初始化簇心
sample_num = size(data, 1);       % 样本数量
sample_dimension = size(data, 2); % 每个样本特征维度


% 簇心赋初值：计算所有数据的均值，并将一些小随机向量加到均值上
clusters = zeros(K, sample_dimension);
minVal = min(data); % 各维度计算最小值
maxVal = max(data); % 各维度计算最大值

for i=1:K
    clusters(i, :) = minVal + (maxVal - minVal) * rand();
end 


hold on; % 在上次绘图（散点图）基础上，准备下次绘图
% 绘制初始簇心
scatter(clusters(:,1), clusters(:,2), 'red', 'filled'); % 实心圆点，表示簇心初始位置

c = zeros(sample_num, 1); % 每个样本所属簇的编号

PRECISION = 0.001;


iter = 100; % 假定最多迭代100次
basic_eta = 0.1;  % 学习率
for i=1:iter
    pre_acc_err = 0;  % 上一次迭代中，累计误差
    acc_err = 0;  % 累计误差
    for j=1:sample_num
        x_j = data(j, :);     % 取得第j个样本数据

        % 所有簇心和x计算距离，找到最近的一个（比较簇心到x的模长）
        gg = repmat(x_j, K, 1);
        gg = gg - clusters;
        tt = arrayfun(@(n) norm(gg(n,:)), (1:K)');
        [minVal, minIdx] = min(tt);

        % 更新簇心：把最近的簇心(winner)向数据x拉动。 eta为学习率.
        eta = basic_eta/i;
        delta = eta*(x_j-clusters(minIdx,:));
        clusters(minIdx,:) = clusters(minIdx,:) + delta;
        acc_err = acc_err + norm(delta);
    end
    
    if(rem(i,10) ~= 0)
        continue
    end
    figure;
    f = scatter(x, y, 20, 'blue');
    hold on;
    scatter(clusters(:,1), clusters(:,2), 'filled'); % 实心圆点，表示簇心初始位置
    title(['第', num2str(i), '次迭代']);
    if (abs(acc_err-pre_acc_err) < PRECISION)
        disp(['收敛于第', num2str(i), '次迭代']);
        break;
    end
     disp((clusters(:,1)));
     disp((clusters(:,2)));

    disp(['累计误差：', num2str(abs(acc_err-pre_acc_err))]);
    pre_acc_err = acc_err;
end


disp('done');
