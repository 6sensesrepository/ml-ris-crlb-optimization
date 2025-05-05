function Y = pySigmoid(X)
%PYSIGMOID Returns sigmoid of the input X
% at::Tensor at::sigmoid(const at::Tensor &self)

import mlp_model_40phases_smoothed.ops.*

Yval = sigmoid(X.value);
Yrank = X.rank;
Y = struct('value', Yval, 'rank', Yrank);
end
