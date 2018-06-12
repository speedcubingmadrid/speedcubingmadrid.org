# frozen_string_literal: true

# This module can be included by a model willing to have tags.
# The including model must have a has_many relationship to their tags table,
# and the relation must be named the following way:
#  - "my_foo_tags" for the MyFoo model
#  - "foo_tags" for the Foo model
#  Thanks WCA: https://raw.githubusercontent.com/thewca/worldcubeassociation.org/master/WcaOnRails/app/models/concerns/taggable.rb
module Taggable
  extend ActiveSupport::Concern

  TAG_REGEX = /\A[-+a-zA-Z0-9]+\z/
  TAG_REGEX_MESSAGE = "only allows English letters, numbers, hyphens, and '+'"

  private def item_tags
    public_send("#{self.class.name.underscore}_tags")
  end

  included do
    attr_writer :tags_string

    has_many :"#{self.name.underscore}_tags", autosave: true, dependent: :destroy
    has_many :tags, through: :"#{self.name.underscore}_tags"

    def tags_string
      @tags_string ||= item_tags.pluck(:tag_name).join(",")
    end

    def tags_array
      tags_string.split(",")
    end

    before_validation do
      tags_array.each do |tag_name|
        item_tags.find_or_initialize_by(tag_name: tag_name)
      end

      item_tags.each do |item_tag|
        item_tag.mark_for_destruction unless tags_array.include?(item_tag.tag_name)
      end
    end

    after_validation do
      # Fix display of error messages, as we show the tags as "tags_string" in the form
      if @errors&.messages.has_key?(:"#{self.class.name.underscore}_tags.tag_name")
        @errors.messages[:tags_string] = @errors.messages[:"#{self.class.name.underscore}_tags.tag_name"]
      end
    end
  end
end
