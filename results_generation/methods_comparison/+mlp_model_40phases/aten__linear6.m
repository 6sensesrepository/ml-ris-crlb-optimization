classdef aten__linear6 < nnet.layer.Layer & nnet.layer.Formattable
    %aten__linear6 Auto-generated custom layer
    % Auto-generated by MATLAB on 28-May-2024 13:04:50
    
    properties (Learnable)
        % Networks (type dlnetwork)
        
    end
    
    properties
        % Non-Trainable Parameters
        
    end
    
    properties (Learnable)
        % Trainable Parameters
        
        Param_weight
        Param_bias
    end
    
    methods
        function obj = aten__linear6(Name, Type, InputNames, OutputNames)
            obj.Name = Name;
            obj.Type = Type;
            obj.NumInputs = 2;
            obj.NumOutputs = 2;
            obj.InputNames = InputNames;
            obj.OutputNames = OutputNames;
        end
        
        function [linear_input_1, linear_input_1_rank] = predict(obj,linear_argument1_1, linear_argument1_1_rank)
            
            if ~contains(dims(linear_argument1_1),'U')
                [linear_argument1_1] = struct('value', linear_argument1_1, 'rank', ndims(linear_argument1_1));
            else
                [linear_argument1_1] = struct('value', linear_argument1_1, 'rank', int64(numel(linear_argument1_1_rank)));
            end
            
            import mlp_model_40phases.ops.*;
            
            linear_weight_1 = obj.Param_weight;
            
            [linear_weight_1] = struct('value', linear_weight_1, 'rank', 2);
            
            linear_bias_1 = obj.Param_bias;
            
            [linear_bias_1] = struct('value', linear_bias_1, 'rank', 1);
            
            [linear_input_1] = pyLinear(linear_argument1_1, linear_weight_1, linear_bias_1);
            [linear_input_1_rank] = ones([1,linear_input_1.rank]);
            linear_input_1_rank = dlarray(linear_input_1_rank,'UU');
            linear_input_1 = linear_input_1.value ;
            
        end
        
        
        
        function [linear_input_1, linear_input_1_rank] = forward(obj,linear_argument1_1, linear_argument1_1_rank)
            
            if ~contains(dims(linear_argument1_1),'U')
                [linear_argument1_1] = struct('value', linear_argument1_1, 'rank', ndims(linear_argument1_1));
            else
                [linear_argument1_1] = struct('value', linear_argument1_1, 'rank', int64(numel(linear_argument1_1_rank)));
            end
            
            import mlp_model_40phases.ops.*;
            
            linear_weight_1 = obj.Param_weight;
            
            [linear_weight_1] = struct('value', linear_weight_1, 'rank', 2);
            
            linear_bias_1 = obj.Param_bias;
            
            [linear_bias_1] = struct('value', linear_bias_1, 'rank', 1);
            
            [linear_input_1] = pyLinear(linear_argument1_1, linear_weight_1, linear_bias_1);
            [linear_input_1_rank] = ones([1,linear_input_1.rank]);
            linear_input_1_rank = dlarray(linear_input_1_rank,'UU');
            linear_input_1 = linear_input_1.value ;
            
        end
        
        
    end
end

