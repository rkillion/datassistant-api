class ActionsController < ApplicationController
    before_action :confirm_authentication
    before_action :set_datassistant

    def new
        if params[:make]
            if params[:make]=="type"
                new_type = Type.new(
                    datassistant_id: @datassistant.id,
                    title_singular: params[:title_singular],
                    title_plural: params[:title_plural]
                )
                if new_type.valid?
                    if params[:parent_type_id]!=""
                        parent = @datassistant.types.find(params[:parent_type_id])
                        sub_type = parent.make_subtype(params[:title_singular],params[:title_plural])
                        render json: sub_type
                    else
                        new_type.save
                        Log.create(
                            datassistant_id: @datassistant.id,
                            type_a_id: new_type.id,
                            reference: "type",
                            action: "created"
                        )
                        Log.create(
                            datassistant_id: @datassistant.id,
                            type_a_id: new_type.id,
                            relationship: "base"
                        )
                        render json: new_type
                    end
                else
                    render json: {errors: new_type.errors}, status: :unprocessable_entity
                end
            elsif params[:make]=="instance"
                new_instance = Instance.new(
                    datassistant_id: @datassistant.id,
                    name: params[:name]
                )
                if new_instance.valid?
                    if params[:parent_type_id]
                        parent = @datassistant.types.find(params[:parent_type_id])
                        instance = parent.make_instance(params[:name])
                        render json: instance
                    else
                        render json: {errors: ["Instances must be created with a parent type."]}
                    end
                else
                    render json: {errors: new_instance.errors}, status: :unprocessable_entity
                end
            else
                render json: {errors: ["invalid item to make"]}, status: :unprocessable_entity
            end
        else
            render json: {errors: ["include 'make' field to define what you are creating"]}, status: :unprocessable_entity
        end
    end

    def note
        if params[:reference] == "base_type"
            assistant_base_types = @datassistant.base_types
            common_base_types = BaseType.all.where(datassistant_id: nil)
            assistant_base_types << common_base_types
            base_type = assistant_base_types.find(params[:base_type_a_id])
            log = Log.new(
                reference: "base_type",
                datassistant_id: @datassistant.id,
                note: params[:note],
                action: params[:action_entry],
                base_type_a_id: base_type.id
            )
            if log.save
                render json: log
            else
                render json: {errors: log.errors}, status: :unprocessable_entity
            end
        elsif params[:reference] == "type"
            type = @datassistant.types.find(params[:type_a_id])
            log = Log.new(
                reference: "type",
                datassistant_id: @datassistant.id,
                note: params[:note],
                action: params[:action_entry],
                type_a_id: type.id
            )
            if log.save
                render json: log
            else
                render json: {errors: log.errors}, status: :unprocessable_entity
            end
        elsif params[:reference] == "instance"
            instance = @datassistant.instances.find(params[:instance_a_id])
            log = Log.new(
                reference: "instance",
                datassistant_id: @datassistant.id,
                note: params[:note],
                action: params[:action_entry],
                instance_a_id: instance.id
            )
            if log.save
                render json: log
            else
                render json: {errors: log.errors}, status: :unprocessable_entity
            end
        end
    end

    def assign
        type_a = @datassistant.types.find(params[:type_a_id])
        type_b = @datassistant.types.find(params[:type_b_id])
        type_a.assign_granted_types({
            action: params[:action_title],
            type_b_id: type_b.id,
            to: params[:to]
        });
        render json: type_a
    end

    def add
        type_a = @datassistant.types.find(params[:type_a_id])
        type_b = @datassistant.types.find(params[:type_b_id])
        instance_a = @datassistant.instances.find(params[:instance_a_id])
        instance_b = @datassistant.instances.find(params[:instance_b_id])
        instance_a.assign_instance({
            instance_b_id: instance_b.id,
            type_a_id: type_a.id,
            type_b_id: type_b.id
        })
        render json: instance_a
    end

    private

    def set_datassistant
        @datassistant = current_user.datassistants.find(params[:datassistant_id])
    end

end
