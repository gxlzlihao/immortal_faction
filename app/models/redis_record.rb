# encoding: UTF-8

module RedisRecord

  class Base

    def self.find(attrs)
      common_get_attrs(attrs, :hgetall)
    end

    def self.list(attrs)
      common_get_attrs(attrs, :lrange)
    end

    def self.get(attrs)
      common_get_attrs(attrs, :get)
    end

    def self.common_get_attrs(attrs, op)
      attributes  = If::RedisDistributed.node.send(op, key(attrs))
      attributes.nil? || 0 == attributes.size  ? nil : serialize_from_hash(attributes)
    end

    def self.hset(*args)
      If::RedisDistributed.node.hset *args
    end

    def self.keys(*args)
      If::RedisDistributed.node.keys *args
    end

    def self.hmset(*args)
      If::RedisDistributed.node.hmset *args
    end

    def self.hmget(*args)
      If::RedisDistributed.node.hmget *args
    end

    def self.hgetall(*args)
      If::RedisDistributed.node.hgetall *args
    end

    def self.incrby(*args)
      If::RedisDistributed.node.incrby *args
    end

    def self.set(*args)
      If::RedisDistributed.node.set *args
    end

    def self.get(*args)
      If::RedisDistributed.node.get *args
    end

    def self.lpush(*args)
      If::RedisDistributed.node.lpush *args
    end

    def self.lrange(*args)
      If::RedisDistributed.node.lrange *args
    end

    private

      def self.key(attrs)
        "imf:#{self.name.downcase}:#{attrs}"
      end

      def self.serialize_from_hash(attributes)
        instance  = new
        attributes.each do |key,value|
          next unless instance.respond_to?("#{key}=".to_sym)
          instance.send("#{key}=".to_sym,value)
        end
        instance
      end
  end

end