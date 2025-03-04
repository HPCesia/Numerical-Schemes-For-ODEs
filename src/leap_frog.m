%   leap_frog - 抛物型微分方程数值求解
%   此 Matlab 函数使用向前欧拉法计算一维抛物型微分方程问题的有限差分数值解。
%   即 u'(t) = f(t, u(t)), u(0) = u0
%
%   语法
%       result = leap_frog(T, step, u0, u1, f)
%
%   输入参数
%       T - 方程求解区间为 [0, T]
%           标量
%       step - 网格步数
%           标量
%       u0 - 初始值
%           标量
%       u1 - 第二个差分点的函数值
%           标量
%       f - 参数为标量 t 和标量 u 的微分方程函数句柄
%           函数句柄
%
%   输出参数
%       result - 微分方程的数值解
%           向量
function [x, result] = leap_frog(T, step, u0, u1, f)
    x = linspace(0, T, step + 1);
    h = T / step;
    result = zeros(1, step + 1);
    result(1) = u0;
    result(2) = u1;
    for k = 3:step + 1
        result(k) = result(k - 2) + 2 * h * f(x(k - 1), result(k - 1));
    end
end
