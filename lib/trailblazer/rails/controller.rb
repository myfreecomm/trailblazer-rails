module Trailblazer::Rails
  module Controller
    def run(operation, *dependencies)
      result = operation.({params: _run_params(self.params) }.merge(*_run_runtime_options(*dependencies)))

      @model = result[:model]
      @form  = Trailblazer::Rails::Form.new( result[ "contract.default" ], @model.class )

      yield(result) if result.success? && block_given?

      @_result = result
    end

  private
    # Override to tweak params. Not recommended.
    # Use a deserializer instead.
    def _run_params(params)
      params
    end

    # This is where we can inject Dry.RB containers and the like via dependencies.
    def _run_runtime_options(ctx={}, *dependencies)
      [_run_options(ctx), *dependencies]
    end

    # Override this to inject dependencies such as "current_user"
    # into the runtime options.
    def _run_options(ctx)
      ctx
    end

    module Result
      def result
        @_result
      end
    end

    include Result
  end
end
